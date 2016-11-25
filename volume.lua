volume_widget = wibox.widget.textbox()
-- volume_widget:set_align("right")

function update_volume(widget)
   local fdMaster = io.popen("amixer sget Master")
   local statusMaster = fdMaster:read("*all")
   fdMaster:close()

   -- Capture mute from Master
   statusMaster = string.match(statusMaster, "%[(o[^%]]*)%]")

   -- Capture volume from PCM
   local fd = io.popen("amixer sget PCM")
   local status = fd:read("*all")
   local volume = tonumber(string.match(status, "(%d?%d?%d)%%"))

   if string.find(statusMaster, "on", 1, true) then
       -- For the volume numbers
       volume = "vol:" .. volume .. "% | "
   else
       -- For the mute button
       volume = "vol:" .. volume .. "(M) | "

   end
   widget:set_markup(volume)
end

update_volume(volume_widget)

mytimer = timer({ timeout = 0.2 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()
