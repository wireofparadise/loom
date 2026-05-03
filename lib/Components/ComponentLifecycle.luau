local ComponentLifecycle = {}

ComponentLifecycle.Events = {
	Start = "__loom_start",
	Stop = "__loom_stop",
}

export type Component = { [any]: any }
export type EventHandler = () -> ()
export type EventTrigger = typeof(ComponentLifecycle.Events.Start) | typeof(ComponentLifecycle.Events.Stop)

function ComponentLifecycle.Trigger(component: Component, event: EventTrigger)
	local handler = component[event]

	if handler then
		handler()
	end
end

function ComponentLifecycle.On(component: Component, event: EventTrigger, handler: EventHandler)
	component[event] = handler
end

function ComponentLifecycle.IsValidComponent(component: Component): boolean
	return typeof(component) == "table"
		and (
			(
				component[ComponentLifecycle.Events.Start] ~= nil
				and typeof(component[ComponentLifecycle.Events.Start]) == "function"
			)
			or (
				component[ComponentLifecycle.Events.Stop] ~= nil
				and typeof(component[ComponentLifecycle.Events.Stop]) == "function"
			)
		)
end

return ComponentLifecycle
