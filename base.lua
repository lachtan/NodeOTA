local NtpErrorCode = {
	[1] = "DNS lookup failed",
	[2] = "Memory allocation failure",
	[3] = "UDP send failed",
	[4] = "Timeout, no NTP response received"
}

function ntpSync(ip)
	local function synced(sec, usec, server)
		print('ntp synced server=' .. server .. ' sec=' .. sec .. ' usec=' .. usec)
	end

	local function error(errorCode) 
		print('ntp sync failed: ' .. NtpErrorCode[errorCode])
	end

	sntp.sync(ip, synced, error)
end

function onConnectionReady()
	-- ntp.nic.cz
	ntpSync("217.31.202.100")
	--dofile("main.lua")
	dofile("ledhall.lua")
end

function checkConnection()
	local ip = wifi.sta.getip()
	if ip == nil then
		waitForConnection()
	else
		print("connection ready")
		print("ip = " .. ip)
		onConnectionReady()
	end	
end

function waitForConnection()
	tmr.alarm(0, 100, tmr.ALARM_SINGLE, checkConnection)
end

wifi.setmode(wifi.STATION)
wifi.sta.config("XXX", "YYY")
wifi.sta.autoconnect(1)
waitForConnection(onConnectionReady)
