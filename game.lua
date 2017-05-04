game = {}
function game.load()
  --加载游戏运行时资源
  --子弹属性
  game.bullet     = imgs.bullet
  game.bulletTab  = {}
  game.bulletSpeed=240
  game.bulletScale=1
  --敌人属性
  game.enemy      = imgs.enemy
  game.enemyWidth = game.enemy:getWidth()
  game.enemyHeight= game.enemy:getHeight()
  game.enemyScale = 2
  game.enemyTable = {}
  game.enemySpeed = 40
  game.enemyHP = 100
  --玩家属性
  game.player     = imgs.player
  game.playerScale= 2
  game.playerX    = window.width / 2
  game.playerY    = window.height - game.enemyHeight * game.playerScale
  game.playerXSpeed= 5
  game.playerAttack= 50
  game.enemyHP     = 100
  --系统属性
  game.score      = 0
  game.oneShootScore = 10
  game.time_now   = 0
  game.bulletTotal= 0
  game.hitTotal   = 0
  game.hitRate    = 0
  
  game.gamebg = imgs.gamebg
  --背景音乐
end

function game.draw()
  love.graphics.draw(game.gamebg,0,0,0,0.5,0.5)
  
  local r,g,b = love.graphics.getColor()
  love.graphics.setColor(0,255,0)
  --显示分数
  love.graphics.print("Score : " .. game.score,10,10)
  local hitRate = 0
  if game.bulletTotal ~= 0 then
    hitRate = (game.hitTotal/game.bulletTotal)-(game.hitTotal/game.bulletTotal) % 0.01
  end
  love.graphics.print("Hit Rate : " .. hitRate,10,40)
  --显示所有的敌人
  if is_debug then
    love.graphics.print("Enemy Counts : " .. #game.enemyTable,10,20)
  end
  
  for i,v in ipairs(game.enemyTable) do
    love.graphics.print("HP:" .. v.HP,v.x,v.y-10) 
    love.graphics.draw(game.enemy,v.x,v.y,0,game.enemyScale,game.enemyScale)
  end
  --显示玩家
  love.graphics.draw(game.player,game.playerX,game.playerY,0,game.playerScale,game.playerScale)
  
  --显示子弹
  if is_debug then
    love.graphics.print("Bullet Counts : " .. #game.bulletTab,10,30)
  end
  love.graphics.setColor(r,g,b)
  for i,v in ipairs(game.bulletTab) do
    love.graphics.draw(game.bullet,v.x,v.y,0,game.bulletScale,game.bulletScale)
  end
end

--如果敌人小于某个值，生成敌人
--可以实现成多少时间内生成，不要马上生成
function game.generateEnemy(dt)
  local MAX_ENEMY = 10
  if #game.enemyTable < MAX_ENEMY then
    if is_debug then
      print("game.enemyCount " .. #game.enemyTable .. " game.generateEnemy")
    end
    
    local enemyObj = {}
    local enemyWidth = game.enemy:getWidth()
    local enemyHeight= game.enemy:getHeight()
    enemyObj.x = math.random(10,window.width)
    enemyObj.y = enemyHeight
    enemyObj.HP= game.enemyHP
    table.insert(game.enemyTable, enemyObj)
  end
end

function game.getDistance(sx,sy,ex,ey)
  return math.sqrt((sx-ex)^2 + (sy-ey)^2)
end

function game.isAtacked(enemy, bulletX,bulletY)
  
  if enemy.x < bulletX + game.bullet:getWidth()*game.bulletScale and 
     enemy.x + game.enemy:getWidth()*game.enemyScale > bulletX and 
     enemy.y < bulletY + game.bullet:getHeight()*game.bulletScale and 
     enemy.y + game.enemy:getHeight()*game.enemyScale > bulletY then
       return true
  else
      return false
  end
  --[[
  local MIN_DIS = 5
  local distance = game.getDistance(enemy.x,enemy.y,bulletX,bulletY)
  if distance < 5 then
    return true
  else
    return false
  end
  ]]--
end

function game.update(dt)
  
  --生成敌人，更新敌人位置
  game.generateEnemy(dt)
  for i,v in ipairs(game.enemyTable) do
    game.enemyTable[i].y = game.enemyTable[i].y + dt * game.enemySpeed
    if game.enemyTable[i].y > window.height then
      table.remove(game.enemyTable, i)
    end
  end
  --更新子弹位置
  for i,v in ipairs(game.bulletTab) do
    game.bulletTab[i].y = game.bulletTab[i].y - dt * game.bulletSpeed
    if game.bulletTab[i].y < 0 then
      game.bulletTotal = game.bulletTotal + 1
      table.remove(game.bulletTab,i)
    end
    --检查是否命中敌人
    for ei,ev in ipairs(game.enemyTable) do
      if game.isAtacked(ev,v.x,v.y) then
        game.bulletTotal = game.bulletTotal + 1
        game.hitTotal = game.hitTotal + 1
        table.remove(game.bulletTab,i)
        if game.playerAttack >=  ev.HP then
          table.remove(game.enemyTable,ei)
          game.score = game.score + game.oneShootScore
        else
          game.enemyTable[ei].HP = game.enemyTable[ei].HP - game.playerAttack
        end
      end
    end
  end
  --把下面这段放到game.keypressed(key)，常按方向键没有效果
  if love.keyboard.isDown("left") then
    game.playerX = game.playerX - game.playerXSpeed
    if game.playerX < 0 then
       game.playerX = 0
    end
  elseif love.keyboard.isDown("right") then
    game.playerX = game.playerX + game.playerXSpeed
    if game.playerX > window.width - game.player:getWidth()*game.playerScale then
      game.playerX = window.width - game.player:getWidth()*game.playerScale
    end
  end
   
end

function game.keypressed(key)
  --[[if key == " " and game.ammo > 0 then
    love.audio.play(shoot)
    game.ammo = game.ammo - 1 --子弹个数减1
    local bullet = {}
    bullet.x = game.playerx
    bullet.y = game.playery
    table.insert(game.bullets,bullet) --添加到运动的子弹里
	end
  ]]--
  --发射子弹
  if key == "a" or key == "A" then
    local bullet = {}
    
    bullet.x = game.playerX + game.player:getWidth()
    bullet.y = game.playerY
    table.insert(game.bulletTab,bullet)
  end
end