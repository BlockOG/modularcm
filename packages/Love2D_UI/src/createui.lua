MainMenu = UIContainer:new()
SelectSize = UIContainer:new()
Overlay = UIContainer:new()
Settings = UIContainer:new()

love.graphics.setBackgroundColor(0.1,0.1,0.1)
do
  local maintext = UIText:new(5,5,"Main Menu","topleft",2)
  local lowertext = UIText:new(5,35,"ModularCM by A Monitor#1595\nUI system by A Monitor#1595\nLove2D UI by Blendi Goose#0414","topleft",1)
  local playbutton = UIButton:new(5,120,64,64,function() GameScreen = "SelectSize" end, love.graphics.newImage("packages/Love2D_UI/textures/mover.png"),"topleft")
  local playtext = UIText:new(75,135,"Play","topleft",2)

  local playibutton = UIButton:new(5,190,64,64,function() ResetCam() Grid = DynamicGrid() GameScreen = "Grid" Placecells = false  end, love.graphics.newImage("packages/Love2D_UI/textures/generator.png"),"topleft")
  local playitext = UIText:new(75,205,"Play as Infinite","topleft",2)

  local settingsbutton = UIButton:new(5,260,64,64,function() ResetCam() Grid = DynamicGrid() GameScreen = "Settings" end, love.graphics.newImage("packages/Love2D_UI/textures/settings.png"),"topleft")
  local settingstext = UIText:new(75,275,"Settings","topleft",2)

  local quitbutton = UIButton:new(5,69,64,64,function() love.event.quit() end,love.graphics.newImage("packages/Love2D_UI/textures/quit.png"),"bottomleft")
  local quittext = UIText:new(75,54,"Quit Game","bottomleft",2)

  MainMenu:insertAll({maintext,lowertext,playbutton,playtext,playibutton,playitext,settingsbutton,settingstext,quitbutton,quittext})
end

do
  local widthselect = UITextbox:new(-120,-10,100,40,"center",2,true,3,999,"Width",function() return true end)
  local heightselect = UITextbox:new(20,-10,100,40,"center",2,true,3,999,"Height",function() return true end)

  local backbutton = UIButton:new(5,5,32,32,function() GameScreen = "mainmenu" end, love.graphics.newImage("packages/Love2D_UI/textures/back.png"),"topleft")
  local backtext = UIText:new(40,3,"Back","topleft",2)

  local playbutton = UIButton:new(-32,50,64,64,function() ResetCam() Grid = FixedGrid(tonumber(SelectSize.children[1]:GetText()) or 100, tonumber(SelectSize.children[2]:GetText()) or 100) GameScreen = "Grid" Placecells = false end, love.graphics.newImage("packages/Love2D_UI/textures/mover.png"),"center")
  local starttext = UIText:new(-30,110,"Start","center",2)

  SelectSize:insertAll({widthselect, heightselect, backbutton, backtext, playbutton, starttext})
end

do
  local backbutton = UIButton:new(5,5,32,32,function() GameScreen = "mainmenu" Placecells = false end, love.graphics.newImage("packages/Love2D_UI/textures/back.png"),"topleft")
  local backtext = UIText:new(40,3,"Back","topleft",2)
  Overlay:insertAll({backbutton, backtext})
end

do
  local backbutton = UIButton:new(5,5,32,32,function() GameScreen = "mainmenu" end, love.graphics.newImage("packages/Love2D_UI/textures/back.png"),"topleft")
  local backtext = UIText:new(40,3,"Back","topleft",2)

  local tickdelayslider = UISlider:new(-200,-100,400,20,0.1,0,2,function(val) local prec = 100 val = math.max(math.floor(val*prec)/prec, 0.001) TickDelay = val Settings.children[4].text = "Tick Delay: " .. tostring(TickDelay) .. "s" end,"center")
  local tickdelaytext = UIText:new(-200,-140,"Tick Delay: 0.2s","center",2)

  Settings:insertAll({backbutton, backtext, tickdelayslider, tickdelaytext})
end