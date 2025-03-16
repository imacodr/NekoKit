function Box(scope, props)
	print(props)
	return scope:FusionNew("Frame")(props)
end

return Box
