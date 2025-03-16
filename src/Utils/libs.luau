-- libs
-- Import external libs to NekoKit.

local Root = script.Parent.Parent
local Packages = script.Parent.Parent.Parent

local logger = require(script.Parent.logger)
local Fusion = require(Packages.Fusion)

export type Libs = {
	[string]: any,
}

export type NekoLib = {
	name: string,
	version: string?,
	theme: { [string]: any },
	components: { [string]: any },
}

function getLibInfo(lib: NekoLib)
	if #lib == 0 then
		return logger:logWarning("failedToLoadExternalLib", lib:GetFullName())
	end

	lib.theme = { [lib.name] = lib.theme }

	print(lib.theme)

	return lib
end

function loadExternalLib(scope: Fusion.Scope, path: any)
	local lib = require(path)

	if not lib then
		return logger:logWarning("failedToLoadExternalLib", path:GetFullName())
	end

	local res

	xpcall(function()
		res = lib.initiate(scope)

		if res then
			res = getLibInfo(res)
		else
			return logger:logWarning("failedToInitiateExternalLib", path:GetFullName())
		end
	end, function(err)
		return logger:logError("failedToInitiateExternalLib", path:GetFullName(), err)
	end)

	return res
end

return {
	getLibInfo = getLibInfo,
	loadExternalLib = loadExternalLib,
}
