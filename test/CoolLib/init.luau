--[[
    Initiates the CoolLib library with the given scope.
    @param scope The scope in which the library is initiated.
]]
function initiate(scope)
	return {
		name = "CoolLib",
		theme = {
			Sigma = Color3.fromRGB(255, 0, 0),
		},
		components = {
			Box = function(props)
				return require(script.Box)(scope, props)
			end,
		},
	}
end

return {
	initiate = initiate,
}
