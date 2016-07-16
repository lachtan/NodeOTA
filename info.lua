local BootReasonTable = {
	[1] = "power-on",
	[2] = "reset",
	[3] = "hardware reset via reset pin",
	[4] = "WDT reset"
}

local BootResetTable = {
	[0] = "power-on",
	[1] = "hardware watchdog reset",
	[2] = "exception reset",
	[3] = "software watchdog reset",
	[4] = "software restart",
	[5] = "wake from deep sleep",
	[6] = "external reset"
}

function nodeInfo()
	local info = node.info()
	return {
		["major-version"] = info[1], 
		["minor-version"] = info[2],
		["device-version"] = info[3], 
		["chip-id"] = info[4], 
		["flash-id"] = info[5], 
		["flash-size"] = info[6], 
		["flash-mode"] = info[7], 
		["flash-speed"] = info[8]
	}	
end

function bootReason()
	local reason, reset = node.bootreason()
	local info = {
		reason = BootReasonTable[reason],
		reset = BootResetTable[reset]
	}
	return info
end

function aboutNode()
	return {
		noed = nodeInfo(),
		restart = bootReason()
	}
end

function dumpAP()
	local function listap(aptable)
		for ssid, info in pairs(aptable) do
			authmode, rssi, bssid, channel = string.match(info, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
			print(ssid, authmode, rssi, bssid, channel)
		end
	end
	wifi.sta.getap(listap)
end

function fsInfo()
	local remaining, used, total = file.fsinfo()
	return {remaining = remaining, used = used, total = total}
end
