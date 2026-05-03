local Log = require(script.Parent.Log)

local Service = {}

Service.Start = "__loom_lifecycle_start"
Service.Stop = "__loom_lifecycle_stop"

export type Table = { [any]: any }
export type Trigger = typeof(Service.Start) | typeof(Service.Stop)
export type EventHandler = (...any) -> () | any

local SERVICE_TAG = "__loom_isService"
local IS_STARTED_TAG = "__loom_isStarted"

function Service.Create(table: Table)
	if typeof(table) ~= "table" then
		Log.Warn("failed to register service: given object is not a valid service")
		return
	end

	table[SERVICE_TAG] = true
end

function Service.On(service: Table, trigger: Trigger, func: EventHandler)
	if not Service.IsService(service) then
		Log.Warn("cannot annotate object because it's not a valid loom service")
		return
	end

	service[trigger] = func
end

function Service.Trigger(service: Table, trigger: Trigger, ...: any)
	if not Service.IsService(service) then
		Log.Warn("failed to trigger service event: given object is not a valid service")
		return
	end

	if trigger == Service.Start then
		if service[IS_STARTED_TAG] then
			Log.Warn("failed to start service: already started")
			return
		end

		service[IS_STARTED_TAG] = true
	elseif trigger == Service.Stop then
		if not service[IS_STARTED_TAG] then
			Log.Warn("failed to stop service: not started")
			return
		end

		service[IS_STARTED_TAG] = false
	end

	local handler = service[trigger]

	if handler then
		handler(...)
	end
end

function Service.IsStarted(service: Table): boolean
	if not Service.IsService(service) then
		return false
	end

	return service[IS_STARTED_TAG]
end

function Service.IsService(table: Table): boolean
	return typeof(table) == "table" and table[SERVICE_TAG] == true
end

return Service
