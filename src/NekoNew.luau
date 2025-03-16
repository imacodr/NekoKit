local Root = script.Parent
local Packages = script.Parent.Parent
local Fusion = require(Packages.Fusion)

local Utils = Root.Utils
local propwork = require(Utils.propwork)

function getCustomClassName(scope: Fusion.Scope, name: string): boolean
	local libs

	if scope.Libs then
		libs = scope.Libs
	else
		libs = {}
	end

	for _, lib in pairs(libs) do
		print(lib)
		for index, component in pairs(lib.components) do
			if index == name then
				return true, component, lib
			end
		end
	end

	return false, nil
end

function NekoNew(scope: Fusion.Scope, className: string, properties: table): Instance
	local isCustom, customComponent, lib = getCustomClassName(scope, className)

	if isCustom then
		return customComponent(propwork.validateProps(scope, properties, lib))
	else
		return scope:FusionNew(className)(propwork.validateProps(scope, properties))
	end
end

return NekoNew
