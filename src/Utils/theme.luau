--!strict

-- theme
-- A module that contains functions to build a NekoTheme.
-- @module theme

local Root = script.Parent.Parent
local Packages = script.Parent.Parent.Parent

local LibsTypes = Root.Utils.libs

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
function checkTheme(scope: Fusion.Scope, value: string, lib: LibsTypes.NekoLib?)
	if not scope.Theme then
		error("No theme found in scope.")
	end

	if typeof(value) ~= "string" then
		return value
	end

	-- First check lib theme if provided
	if lib then
		local libTheme = scope.Theme.Libs and scope.Theme.Libs[lib.name]
		print(libTheme)
		if libTheme then
			local keys = string.split(value, ".")
			local themeValue = libTheme

			for _, key in ipairs(keys) do
				if not themeValue[key] then
					break -- Break if key not found in lib theme
				end
				themeValue = themeValue[key]
			end

			if themeValue ~= libTheme then -- If we found a value in lib theme
				return themeValue
			end
		end
	end

	-- Fall back to global theme
	local themeValue = scope.Theme
	local keys = string.split(value, ".")

	for _, key in ipairs(keys) do
		themeValue = themeValue[key]
		if not themeValue then
			return nil
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
