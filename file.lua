File = {}
File.__index = File
File.__call = function(_, ...) return File:new(...) end
setmetatable(File, File)

function File:new(filename, mode)
	local info = {filename = filename, mode = mode}
	return setmetatable(info, self)
end

function File:write(text)
	file.open(self.filename, "w")
	file.write(text)
	file.close()
end

function File:append(text)
	file.open(self.filename, "a")
	file.write(text)
	file.close()
end

function File:readlines()
	file.open(self.filename, "r")
	lines = {}
	while 1 do
		local line = file.readline()
		if line == nil then
			return lines
		else
			lines[#lines + 1] = line
		end
	end
end

function File:sha1()
	return crypto.toHex(crypto.fhash("sha1", self.filename))
end

function log(text)
	self:append(time.stamp() .. " " .. text .. "\n")
end

function File:dump()
	-- moznost cislovat radky
	file.open(self.filename, "r")
	while 1 do
		local line = file.readline()
		if line == nil then
			return
		else
			print(rtrim(line))
		end
	end
end
