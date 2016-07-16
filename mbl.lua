function include(libraryName)
	local filename = libraryName .. ".lua"
	if not file.exists(filename) then
		node.compile(filename)
	end
	local compiled = libraryName .. ".lc"
	dofile(compiled)
end

function append(array, item)
	array[#array + 1] = item
	return array
end

function extend(array, otherArray)
	for key, value in ipairs(otherArray) do
		append(array, value)
	end
	return array
end

function toArray(iterator)
	local array = {}
	for item in iterator do
		append(array, item)
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

function rtrim(text)
	return text:match "(.-)%s*$"
end

function trim(text)
	return text:match "^%s*(.-)%s*$"
end

function endWith(text, suffix)
	return text:sub(1 + text:len() - suffix:len()) == suffix
end

function trimSuffix(text, suffix)
	if endWith(text, suffix) then
		return text:sub(0, text:len() - suffix:len())
	else
		return text
	end
end

function split(text)
	return toArray(string.gmatch(text, "%S+"))
end
