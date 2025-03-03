local Root = script.Parent
local Packages = script.Parent.Parent
local Fusion = require(Packages.Fusion)

local Utils = Root.Utils
local propwork = require(Utils.propwork)

function NekoNew(scope: Fusion.Scope, className: string, properties: table): Instance
	return scope:FusionNew(className)(propwork.validateProps(scope, properties))
end

return NekoNew
