local commands = {}

local json = require "json"

---@type FixedGrid|DynamicGrid|nil
Grid = nil

IsWindows = package.config:sub(1, 1) == '\\'

function ScanDir(directory)
  local i, t, popen = 0, {}, io.popen
  local pfile
  if IsWindows then
    pfile = popen('dir "' .. directory .. '" /b')
  else
    pfile = popen('ls -a "' .. directory .. '"')
  end
  for filename in pfile:lines() do
    if filename:sub(1, 1) ~= "." then
      i = i + 1
      t[i] = filename
    end
  end
  pfile:close()
  return t
end

function IsDir(path)
  local f = io.open(path)
  ---@diagnostic disable-next-line: need-check-nil
  return not f:read(0) and f:seek("end") ~= 0
end

function BindCommand(commandName, runner)
  commands[commandName] = runner
end

BindCommand("exit", function() os.exit(0) end)

---@param cmd string
---@param args table
function Shell(cmd, args)
  local command = commands[cmd]
  if command then
    command(args)
  else
    print("Unknown command: " .. cmd)
  end
end

---@param str string
---@param s string
function SplitStr(str, s)
  local sep, fields = s or " ", {}
  local pattern = string.format("([^%s]+)", sep)
  local _, _ = str:gsub(pattern, function(c) fields[#fields + 1] = c end)
  return fields
end

function ParseCommand(str)
  local cmd = SplitStr(str, " ")

  local cmdname = cmd[1]
  local args = {}
  for i = 2, #cmd do
    args[i - 1] = cmd[i]
  end

  return cmdname, args
end

function RunCmd(str)
  local cmdname, args = ParseCommand(str)
  Shell(cmdname, args)
end

local _queues = {}

function CreateQueue(queue)
  if not _queues[queue] then _queues[queue] = {} end
end

function RunQueue(queue, ...)
  local q = _queues[queue] or {}

  while #q > 0 do
    local f = q[1]
    table.remove(q, 1)
    f(...)
  end
end

function Queue(queue, func)
  if not _queues[queue] then CreateQueue(queue) end
  table.insert(_queues[queue], func)
end

CreateQueue "init"
CreateQueue "pre-cmd"
CreateQueue "post-cmd"

local canShell = true

BindCommand("close-shell", function() canShell = false end)

function ToggleShell()
  canShell = not canShell
end

function CanShell() return canShell end

function JoinPath(...)
  local str = ""

  local t = { ... }

  local sep = "/"
  if IsWindows then sep = "\\" end

  return table.concat(t, sep)
end

require "src.cell"
require "src.grid"

local packages = ScanDir "packages"

local depended = {}
function Depend(...)
  local t = { ... }
  for _, p in ipairs(t) do
    if not depended[p] then
      print("Loaded package " .. p)
      depended[p] = true
      require("packages." .. p .. ".init")
    end
  end
end

for _, package in ipairs(packages) do
  Depend(package)
end

RunQueue "init"

while canShell do
  RunQueue("pre-cmd")
  io.write("> ")
  local line = io.read()
  RunCmd(line)
  RunQueue("post-cmd", line)
end
