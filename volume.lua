volume_widget = widget({ type = "textbox", name = "tb_volume",
                         align = "right" })

function update_volume(widget)
   local fd = io.popen("amixer sget Master")
   local status = fd:read("*all")
   fd:close()

   -- local volume = tonumber(string.match(status, "(%d?%d?%d)%%")) / 100
   local volume = string.match(status, "(%d?%d?%d)%%")
   volume = string.format("% 3d", volume)

   status = string.match(status, "%[(o[^%]]*)%]")

   if string.find(status, "on", 1, true) then
       -- For the volume numbers
       volume = " vol:" .. volume .. "%"
   else
       -- For the mute button
       volume = " vol:" .. volume .. "/M"

   end
   widget.text = volume
end

update_volume(volume_widget)

mytimer = timer({ timeout = 0.2 })
mytimer:add_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()