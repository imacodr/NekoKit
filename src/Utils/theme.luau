--!strict

-- theme
-- A module that contains functions to build a NekoTheme.
-- @module theme

local Packages = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)

export type NekoTheme = {
	[string]: any,
}

-- mergeTables
-- Merges two tables together recursively.
-- @param destination: { [string]: any }
-- @param source: { [string]: any }
local function mergeTables(destination, source)
	for key, value in pairs(source) do
		if type(value) == "table" then
			-- If the value is a table, recursively merge it
			destination[key] = destination[key] or {}
			mergeTables(destination[key], value)
		else
			destination[key] = value
		end
	end
end

-- buildTheme
-- Builds a NekoTheme by merging the global theme, the theme extensions, and the themes of the libs.
-- @param scope: Fusion.Scope
-- @param extensions: { [string]: any }
-- @return NekoTheme
function buildTheme(scope: Fusion.Scope, extensions: { [string]: any }): NekoTheme
	local file = game.ReplicatedStorage:FindFirstChild("global.neko")

	local globalTheme = {}

	if file then
		globalTheme = require(file)
	end

	local finishedTheme = {}

	mergeTables(finishedTheme, globalTheme)
	mergeTables(finishedTheme, extensions)

	local libs

	if scope.Libs then
		libs = scope.Libs
	else
		libs = {}
	end

	for _, lib in pairs(libs) do
		if lib.theme then
			mergeTables(finishedTheme, lib.theme)
		end
	end

	return finishedTheme
end

return {
	buildTheme = buildTheme,
}
