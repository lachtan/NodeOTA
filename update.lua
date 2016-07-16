
-- vsechno logovat na lokal
-- merit cas

local VersionFileName = "version.txt"
local currentVersion = nil

local function currentVersion( ... )
	-- body
end

local function downloadContent(url)
end

local function getVersionInfo()
	-- vrati tabulku s informacemi
	local content = downloadContent()


end

local function downloadFile(fileName, localFileName)
	-- muze vratit chybu
end

local function downloadFileList()
	-- vytvori seznam souboru pro stazeni i jejich jmen docasnych i vyslednych a checksumu
end

local function downloadItems(items)
	for item in items do
		if not downloadFile(item.fileName, item.tmpFileName) then
			return false
		end
		if not fileSha1(item.tmpFileName) ~= item.sha1 then
			file.remove(item.tmpFileName)
			return false
		end
	end
end

local function parseFileList(fileName)
	local items = {}
	file.open(fileName)
	while (line = file.readline()) ~= nil then
		local info = line.trim().split()
		if #info < 2 then
			return nil
		end
		local item = {
			["sha1"] = info[1],
			["fileName"] = info[2],
			["tmpFileName"] = info[2] .. ".new"
		}
		add(items, item)
	end
	file.close()
	return items
end

local function deleteFiles(files)
	for fileName in files do
		file.remove(fileName)
	end
end

local function renameItems(items)
	local renamedFiles = {}
	for item in items do
		if not file.rename(item.tmpFileName, item.fileName) then
			deleteFiles(renamedFiles)
			return false
		end
		add(renamedFiles, item.fileName)
		if endWith(item.fileName) then
			node.compile(item.fileName)
		end
	end
	return true
end

local function writeVersion()
	writeToFile(VersionFileName, curentVersion)
end

function updateFirmware()
	currentVersion = nil
	currentVersion = getCurrentVersion()
	local itemsFileName = downloadFileList()
	local items = parseFileList(itemsFileName)
	if items == nil then
		return false
	end
	if not downloadItems(items) then 
		return false
	end
	if not checkItemsChecksum(items) then
		return false
	end
	renameItems(items)
	writeVersion()
	-- oznam server, ze update dobehl
end

if updateFirmware() then
	-- proved restart nebo neco
end
