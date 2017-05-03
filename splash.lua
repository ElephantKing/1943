splash = {}
function splash.load(img, music)
  splash.time_now = 0
  splash.img = img
  splash.music=love.audio.newSource(music,"stream")
  splash.music:setLooping(true)
  love.audio.play(splash.music)
end

function splash.draw()
  local scaleBg = 1
  love.graphics.draw(splash.img,-100,-100,0,scaleBg,scaleBg)
  
  local titleSpeed = 120
  local titleScale = 2
  love.graphics.draw(imgs.title,180,(splash.time_now - 1)*titleSpeed,0,titleScale,titleScale)
  
end

function splash.update(dt)
  splash.time_now = splash.time_now + dt
  
  if splash.time_now > 2.5 then
    splash.time_now = 2.5
  end
end

function splash.keypressed(key)
  love.audio.stop(splash.music)
  statue = "game"
  game.load()
end