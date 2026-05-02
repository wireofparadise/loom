local Log = require(script.Parent.Log)
local Types = require(script.Parent.Types)

local Service = {} :: Types.ServiceClass
Service.__index = Service

function Service.new(): Types.Service
	local self = setmetatable({}, Service)

	self.__isInitialized = false
	self.__isStarted = false
	self.__methodRegistry = {}

	return self :: any
end

function Service:AddMethod(name: string, func: (...any) -> any)
	if self[name] then
		Log.Warn(string.format("failed to add service method %s: already exists", name))
		return
	end

	self[name] = function(self: Types.Service, ...: any)
		if not self.__isStarted then
			Log.Error(string.format("cannot call service function %s: service is not started", name))
		end

		return func(self, ...)
	end

	table.insert(self.__methodRegistry, name)
end

function Service:OnInit() end

function Service:OnStart() end

function Service:OnStop() end

return Service
