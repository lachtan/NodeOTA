
web = {}

function web.escape(value)
end

function web.escapeParams(params)
	local text = nil
	for key, value in pairs(params) do
		keyValue = web.escape(key) .. "=" .. web.escape(value)
		if text == nil then
			text = keyValue
		else
			text = text .. "&" .. keyValue
		end
	end
	return text
end

function web.get(url, params)
end

function web.downloadFile(url, localFileName)
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

