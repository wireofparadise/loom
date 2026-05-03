local LogLevels = require(script.Parent.LogLevels)
local LoggingTypes = require(script.Parent.LoggingTypes)

local Logger = {}
Logger.__index = Logger

function Logger.new(options: LoggingTypes.LoggerOptions?)
	return setmetatable(
		if options
			then { Scope = options.Scope, LogLevel = if options.Level ~= nil then options.Level else LogLevels.Info }
			else { LogLevel = LogLevels.Info },
		Logger
	)
end

local function getLogLevelName(logLevel: number): string
	if logLevel >= LogLevels.Debug then
		return "debug"
	elseif logLevel >= LogLevels.Info then
		return "info"
	elseif logLevel >= LogLevels.Warn then
		return "warn"
	elseif logLevel >= LogLevels.Error then
		return "error"
	elseif logLevel >= LogLevels.Fatal then
		return "fatal"
	else
		return "unknown"
	end
end

local function getLogFunction(logLevel: number): (message: string) -> ()
	if logLevel <= LogLevels.Fatal then
		return error
	elseif logLevel <= LogLevels.Warn then
		return warn
	else
		return print
	end
end

function Logger:Log(message: string, level: number)
	if level > self.LogLevel then
		return
	end

	local formattedMessage = if self.Scope
		then string.format("[%s] [%s]: %s", getLogLevelName(level), self.Scope, message)
		else string.format("[%s]: %s", getLogLevelName(level), message)

	getLogFunction(level)(formattedMessage)
end

function Logger:Scope(name: string)
	return Logger.new({
		Scope = name,
		Level = self.LogLevel,
	})
end

function Logger:Fatal(fmt: string, ...: any)
	self:Log(self, string.format(fmt, ...), LogLevels.Fatal)
end

function Logger:Error(fmt: string, ...: any)
	self:Log(self, string.format(fmt, ...), LogLevels.Error)
end

function Logger:Warn(fmt: string, ...: any)
	self:Log(self, string.format(fmt, ...), LogLevels.Warn)
end

function Logger:Info(fmt: string, ...: any)
	self:Log(self, string.format(fmt, ...), LogLevels.Info)
end

function Logger:Debug(fmt: string, ...: any)
	self:Log(self, string.format(fmt, ...), LogLevels.Debug)
end

return Logger
