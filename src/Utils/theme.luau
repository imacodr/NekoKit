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

-- checkTheme
-- Checks if a value is a theme value and returns the theme value if it is.
-- @param scope: Fusion.Scope
-- @param value: string
-- @return any
function checkTheme(scope: Fusion.Scope, value: string)
	if not scope.Theme then
		error("No theme found in scope.")
	end

	if typeof(value) ~= "string" then
		return value
	end

	local themeValue = scope.Theme -- Start with the root theme table

	-- Split the value by periods to handle nested values
	local keys = string.split(value, ".")

	-- Traverse the nested keys to access the desired theme value
	for _, key in ipairs(keys) do
		themeValue = themeValue[key]
		if not themeValue then
			return nil -- Return nil if any key is not found
		end
	end

	return themeValue
end

-- buildTheme
-- Builds a NekoTheme by merging the global theme, the theme extensions, and the themes of the libs.
-- @param scope: Fusion.Scope
-- @param extensions: { [string]: any }
-- @return NekoTheme
function buildTheme(scope: Fusion.Scope, extensions: { [string]: any }): NekoTheme
	local file = game.ReplicatedStorage:FindFirstChild("global.neko")

	local globalTheme = { Libs = {} }

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
			mergeTables(finishedTheme, { Libs = { [lib.name] = lib.theme } })
		end
	end

	return finishedTheme
end

return {
	buildTheme = buildTheme,
	checkTheme = checkTheme,
}
