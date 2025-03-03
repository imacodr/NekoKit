-- propwork
-- This module is responsible for validating and resolving theme values for properties.
-- @module propwork

local Utils = script.Parent

local checkTheme = require(Utils.theme).checkTheme

-- Helper function to create padding and corner instances
function createPaddingAndCornerInstances(scope, props)
	local paddingTop = props.PaddingTop or props.PaddingY or props.Padding
	local paddingBottom = props.PaddingBottom or props.PaddingY or props.Padding
	local paddingLeft = props.PaddingLeft or props.PaddingX or props.Padding
	local paddingRight = props.PaddingRight or props.PaddingX or props.Padding

	-- Create padding instance if any padding value exists
	local paddingInstance
	if paddingTop or paddingBottom or paddingLeft or paddingRight then
		paddingInstance = scope:FusionNew("UIPadding")({
			PaddingTop = paddingTop,
			PaddingBottom = paddingBottom,
			PaddingLeft = paddingLeft,
			PaddingRight = paddingRight,
		})
	end

	local cornerRadius
	if typeof(props.CornerRadius) == "number" then
		cornerRadius = UDim.new(0, props.CornerRadius)
	elseif typeof(props.CornerRadius) == "UDim" then
		cornerRadius = props.CornerRadius
	end

	-- Create corner instance if cornerRadius is defined
	local cornerInstance
	if cornerRadius then
		cornerInstance = scope:FusionNew("UICorner")({
			CornerRadius = cornerRadius,
		})
	end

	return paddingInstance, cornerInstance, paddingTop, paddingBottom, paddingLeft, paddingRight, cornerRadius
end

-- Function to handle theme validation and apply theme values
function validateProps(scope, props)
	local finalProps = {}

	-- Iterate through all properties and resolve theme values
	for key, value in pairs(props) do
		local themeValue = checkTheme(scope, value)
		finalProps[key] = themeValue or value
	end

	-- Apply additional validation for specific properties like size, position, etc.
	-- local position = checkPosition(finalProps)
	-- finalProps.PrePosition = nil

	-- local anchorPoint = checkAnchorPoint(finalProps) or position.AnchorPoint
	-- finalProps.AnchorPoint = nil

	local backgroundColor = checkTheme(scope, finalProps.BackgroundColor3)
		or checkTheme(scope, finalProps.BackgroundColor)
		or checkTheme(scope, finalProps.Bg)
		or nil

	finalProps.BackgroundColor3 = backgroundColor
	finalProps.BackgroundColor = nil
	finalProps.Bg = nil

	local children = finalProps[scope.Children]
	finalProps[scope.Children] = children

	createPaddingAndCornerInstances(scope, finalProps)

	return finalProps
end

return { validateProps = validateProps }
