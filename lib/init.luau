local Log = require(script.Log)
local Service = require(script.Service)
local UseRequire = require(script.UseRequire)

local Loom = {}

Loom.Init = Service.Init
Loom.Start = Service.Start
Loom.Stop = Service.Stop

function Loom.CreateService(table: any)
	Service.Create(table)
end

function Loom.On(table: any, trigger: Service.Trigger, func: Service.EventHandler)
	Service.On(table, trigger, func)
end

local services: { { any } } = {}

function Loom.AddSource(source: Instance)
	if source:IsA("ModuleScript") then
		local module = UseRequire(source)

		if not Service.IsService(module) then
			Log.Warn("failed to add source: module is not a valid loom service, did you forget `Loom.CreateService()`?")
			return
		end

		table.insert(services, module)

		Service.Trigger(module, Service.Init)
	end

	for _, child in ipairs(source:GetChildren()) do
		Loom.AddSource(child)
	end
end

function Loom.Run()
	for _, service in ipairs(services) do
		Service.Trigger(service, Service.Start)
	end
end

function Loom.Terminate()
	for _, service in ipairs(services) do
		Service.Trigger(service, Service.Stop)
	end
end

return Loom
