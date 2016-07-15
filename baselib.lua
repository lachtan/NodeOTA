-- General functions for NodeMCU
-- lachtan copyleft

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

function append(array, item)
	array[#array + 1] = item
end

function toArray(iterator)
	local array = {}
	for item in iterator do
		add(array, item)
	end
	return array
end

function isTable(value)
	return type(value) == "table"
end

local function dumpTable(table, depth)
	-- kontrolovat max depth ?
	local space = string.rep("  ", depth)
	for key, value in pairs(table) do 
		if isTable(value) then
			print(space .. key)
			dumpTable(value, depth + 1)
		else
			print(space .. key .. " = " .. value)
		end
	end
end	

function dump(value)
	if isTable(value) then
		dumpTable(value, 0)
	else
		print(value)
	end
end

function trim(text)
	return text:match "^%s*(.-)%s*$"
end

function string:trim()
	return trim(self)
end

function endWith(text, suffix)
	return text:sub(1 + text:len() - suffix:len()) == suffix
end

function string:endWith(suffix)
	return endWith(self, suffix)
end

function trimSuffix(text, suffix)
	if endWith(text, suffix) then
		return text:sub(0, text:len() - suffix:len())
	else
		return text
	end
end

function string:trimSuffix(suffix)
	return trimSuffix(self, suffix)
end

function split(text)
	return toArray(string.gmatch(text, "%S+"))
end

function string:split()
	return split(self)
end

function aboutNode()
	local info = {
		["Node info"] = nodeInfo(),
		["Restart info"] = bootReason()
	}
	dumpTable(info)
end

function catFile(fileName)
	file.open(fileName, "r")
	while 1 do
		local line = os.read()
		if line == nil then 
			break
		end
		print(line)
	end
	file.close()
end

function writeToFile(fileName, content)
	file.open(fileName, "w")
	file.write(content)
	file.close()
end

function appendToFile(fileName, content)
	file.open(fileName)
	file.write(content)
	file.close()
end

function readLineFromFile(fileName)
	file.open(fileName, "r")
	local line = file.readline()
	file.close()
	return line
end

local function fileSha1(fileName)
	return crypto.toHex(crypto.fhash("sha1", fileName))
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

	sntp.sync(
		ip,
		synced,
		function(errorCode) print('ntp sync failed: ' .. NtpErrorCode[errorCode]) end
	)
end

function downloadFile(url, fileName)
	function dataReady(code, data)
		if code < 0 then
			print("HTTP request failed")
		else
			print(code, data)
		end
	end

	local headers = nil
	http.get("http://192.168.4.101/~lachtan/ip.php", headers, dataReady)
end

