local Log = {}

local function formatMessage(message: string): string
	return "Loom: " .. message
end

function Log.Error(message: string)
	error(formatMessage(message))
end

function Log.Warn(message: string)
	warn(formatMessage(message))
end

function Log.Print(message: string)
	print(formatMessage(message))
end

return Log
