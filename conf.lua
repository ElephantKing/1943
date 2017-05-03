scale = 4
is_debug = true
statue = ""
function love.conf(t)
  t.title = "1942 game copy"
  window = t.screen or t.window
  window.width = 160*scale
  window.height= 144*scale
  t.console = is_debug
end