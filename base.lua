dofile("baselib.lua")
dofile("config.lua")

wifi.setmode(wifi.STATION)
wifi.sta.config(SSID, password)
wifi.sta.autoconnect(1)
print("NodeMCU IP: " .. wifi.sta.getip())

ntpSync(NtpIP)
