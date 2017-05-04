require("splash")
require("game")

function love.load()
  imgs_jpeg = {"bg"}
  imgs_png = {"bullet","enemy","player","title","background","gamebg"}
  imgs = {}
  for _,v in ipairs(imgs_jpeg) do
    imgs[v] = love.graphics.newImage("assets/" .. v .. ".jpg")
  end
  
  for _,v in ipairs(imgs_png) do
    imgs[v] = love.graphics.newImage("assets/" .. v .. ".png")
  end
  
  statue = "splash"
  splash.load(imgs.bg,"assets/music.mp3")
end

function love.draw()
  if statue == "splash" then
    splash.draw()
  end
  
  if statue == "game" then
    game.draw()
  end
end

function love.update(dt)
  if statue == "splash" then
    splash.update(dt)
  end
  
  if statue == "game" then
    game.update(dt)
  end
end

function love.keypressed(key)
  if statue == "splash" then
    splash.keypressed(key)
  end
  
  if statue == "game" then
    game.keypressed(key)
  end
end