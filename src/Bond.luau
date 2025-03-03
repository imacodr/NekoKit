--!strict

local Root = script.Parent
local Utils = Root.Utils
local Packages = script.Parent.Parent

local Fusion = require(Packages.Fusion)

local NekoNew = require(Root.NekoNew)
local theme = require(Utils.theme)
local libs = require(Utils.libs)

-- Fusion funcs
local scoped = Fusion.scoped

-- NekoScope
-- A NekoScope is a table that contains all the necessary functions and properties to create a NekoKit instance.
-- It is returned by the Bond function.
export type NekoScope = {
	New: (Fusion.Scope, string) -> (Fusion.Props) -> Instance,
	Id: string,
	GetReference: (Fusion.Scope) -> Instance,
	Theme: theme.NekoTheme,
	Libs: libs.Libs,
	LoadLib: (Fusion.Scope, any) -> (),
	FusionNew: (string) -> (Fusion.Props) -> Instance,
	Value: (string) -> Instance,
	Children: Fusion.Children,
	deriveScope: (Fusion.Scope) -> Fusion.Scope,
	innerScope: Fusion.Scope,
	doCleanup: () -> (),
}

-- Makes sure that overrides are not nil and that the prop is not nil.
function ensureOverrides(overrides: { [string]: any }, prop: string, default: any)
	if overrides and overrides[prop] then
		return overrides[prop]
	else
		return default
	end
end

-- Bond
-- Creates a new NekoScope.
-- @param id: string
-- @param themeExtensions: { [string]: any }
-- @param overrides: { [string]: any }
-- @return NekoScope
function Bond(id: string, themeExtensions: { [string]: any }, overrides: { [string]: any }?): NekoScope
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
		GetReference = function()
			local parent = ensureOverrides(overrides, "Parent", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
			return parent:FindFirstChild("neko_" .. id)
		end,
		LoadLib = function(scope: Fusion.Scope, lib: any)
			scope.Libs[lib.Name] = lib

			scope.Theme = theme.buildTheme(scope, themeExtensions)
		end,
		FusionNew = Fusion.New,
		Value = Fusion.Value,
		Children = Fusion.Children,
		deriveScope = Fusion.deriveScope,
		innerScope = Fusion.innerScope,
		doCleanup = Fusion.doCleanup,
	})

	nekoscope:FusionNew(ensureOverrides(overrides, "ClassName", "ScreenGui"))({
		Name = "neko_" .. id,
		Parent = ensureOverrides(overrides, "Parent", game.Players.LocalPlayer.PlayerGui),
		IgnoreGuiInset = ensureOverrides(overrides, "IgnoreGuiInset", true),
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

	nekoscope.Theme = theme.buildTheme(nekoscope, themeExtensions)

	return nekoscope
end

return Bond
