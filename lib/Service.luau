local Log = require(script.Parent.Log)

local Service = {}

Service.Init = "__loom_lifecycle_init"
Service.Start = "__loom_lifecycle_start"
Service.Stop = "__loom_lifecycle_stop"

export type Trigger = typeof(Service.Init) | typeof(Service.Start) | typeof(Service.Stop)
export type EventHandler = (...any) -> () | any

local SERVICE_TAG = "__loom_isService"

function Service.Create(table: any)
	if typeof(table) ~= "table" then
		Log.Warn("failed to register service: given object is not a valid service")
		return
	end

	table[SERVICE_TAG] = true
end

function Service.On(service: any, trigger: Trigger, func: EventHandler)
	if not Service.IsService(service) then
		Log.Warn("cannot annotate object because it's not a valid loom service")
		return
	end

	local isInitialized = false
	local isStarted = false

	if trigger == Service.Init then
		service[trigger] = function(...: any)
			if isInitialized then
				Log.Warn("failed to initialize service: already initialized")
				return
			end

			local result = (func :: any)(...)

			isInitialized = true

			return result
		end
	elseif trigger == Service.Start then
		service[trigger] = function(...: any)
			if not isInitialized then
				Log.Warn("failed to start service: not initialized")
				return
			end

			if isStarted then
				Log.Warn("failed to start service: already started")
				return
			end

			local result = (func :: any)(...)

			isStarted = true

			return result
		end
	elseif trigger == Service.Stop then
		service[trigger] = function(...: any)
			if not isStarted then
				Log.Warn("failed to stop service: not started")
				return
			end

			local result = (func :: any)(...)

			isStarted = false

			return result
		end
	end
end

function Service.Trigger(service: any, trigger: Trigger, ...: any)
	if not Service.IsService(service) then
		Log.Warn("failed to trigger service event: given object is not a valid service")
		return
	end

	service[trigger](...)
end

function Service.IsService(table: any): boolean
	return typeof(table) == "table" and table[SERVICE_TAG] == true
end

return Service
