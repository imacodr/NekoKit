local Packages = script.Parent.Parent
local Fusion = require(Packages.Fusion)

function NekoNew(scope: Fusion.Scope, className: string, properties: table): Instance
	return scope:FusionNew(className)(properties)
end

return NekoNew
