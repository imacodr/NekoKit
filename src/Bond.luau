local Packages = script.Parent.Parent
local Fusion = require(Packages.Fusion)

local NekoNew = require(script.Parent.NekoNew)

local scoped = Fusion.scoped

function checkExtraProp(extras: { [string]: any }, prop: string, default: any)
	if extras and extras[prop] then
		return extras[prop]
	else
		return default
	end
end

function Bond(id: string, themeExtensions: { [string]: any }, extras: { [string]: any }?)
	local nekoscope = scoped({
		New = function(scope: Fusion.Scope, className: string)
			return function(props: Fusion.Props)
				local instance = NekoNew(scope, className, props)

				if instance.Parent == nil then
					instance.Parent = scope:GetReference():FindFirstChild("Content")
				end

				return instance
			end
		end,
		Id = id,
		GetReference = function(scope: Fusion.Scope)
			local parent = checkExtraProp(extras, "Parent", game.Players.LocalPlayer.PlayerGui)
			return parent:FindFirstChild("neko_" .. id)
		end,
		FusionNew = Fusion.New,
		Value = Fusion.Value,
		Children = Fusion.Children,
		deriveScope = Fusion.deriveScope,
		innerScope = Fusion.innerScope,
		doCleanup = Fusion.doCleanup,
	})

	nekoscope:FusionNew(checkExtraProp(extras, "ClassName", "ScreenGui"))({
		Name = "neko_" .. id,
		Parent = checkExtraProp(extras, "Parent", game.Players.LocalPlayer.PlayerGui),
		IgnoreGuiInset = checkExtraProp(extras, "IgnoreGuiInset", true),
		[nekoscope.Children] = {
			nekoscope:FusionNew("Frame")({
				Name = "Bay",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
			}),
			nekoscope:FusionNew("Frame")({
				Name = "Content",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
			}),
		},
	})

	return nekoscope
end

return Bond
