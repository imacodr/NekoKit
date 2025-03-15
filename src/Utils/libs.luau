-- libs
-- Import external libs to NekoKit.

local logger = require(script.Parent.logger)

export type Libs = {
	[string]: any,
}

function getLibInfo(path: any)
	local lib = require(path)

	if lib then
		return lib
	else
		logger:logWarning("failedToLoadExternalLib", path:GetFullName())
	end

	lib.theme = { [lib.name] = lib.theme }

	print(lib.theme)

	return lib
end

function loadExternalLib(path: any)
	local lib = require(path)

	if lib then
		return lib
	else
		logger:logWarning("failedToLoadExternalLib", path:GetFullName())
	end

	print(lib)
	return
end

return {
	getLibInfo = getLibInfo,
	loadExternalLib = loadExternalLib,
}
