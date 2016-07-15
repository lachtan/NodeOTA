--init.lua

wifi.setmode(wifi.STATION)
wifi.sta.config("ssidname","ssidpassword")
wifi.sta.connect()
tmr.alarm(1, 1000, 1, function()
if wifi.sta.getip()== nil then
    print("Waiting for IP...")
else
    tmr.stop(1)
    print("Your IP is "..wifi.sta.getip())
    dofile("sleep.lua")
end
end)
