local Logger = {}

local errorIDs = require(script.Parent.errorIds)

local function formatErrorMessage(errorID, ...)
	local errorMessageTemplate = errorIDs[errorID]

	if errorMessageTemplate then
		return string.format(errorMessageTemplate, ...)
	else
		return string.format(errorIDs.unknownError, errorID or "N/A")
	end
end

function Logger:logError(errorID, ...)
	local formattedMessage = formatErrorMessage(errorID, ...)
	local fullMessage = string.format("[NekoKit - Error] %s (errorID: %s)", formattedMessage, errorID or "N/A")
	error(fullMessage, 0)
end

function Logger:logWarning(errorID, ...)
	local formattedMessage = formatErrorMessage(errorID, ...)
	local fullMessage = string.format("[NekoKit - Warning] %s (errorID: %s)", formattedMessage, errorID or "N/A")
	warn(fullMessage, 0)
end

return Logger
