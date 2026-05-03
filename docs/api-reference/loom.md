# `Loom`

## Functions

### `AddSource()`

=== "Luau"
    ```luau
    Loom.AddSource(
        source: Instance
    )
    ```

**Parameters:**

- `source` [`Instance`](https://create.roblox.com/docs/reference/engine/classes/Instance) — Source that you want to add.

Loom is going to include this source to be used [`Loom.Run()`](#run) if it's a [`ModuleScript`](https://create.roblox.com/docs/reference/engine/classes/ModuleScript), otherwise it is going to iterate through descendants and include all found [`ModuleScripts`](https://create.roblox.com/docs/reference/engine/classes/ModuleScript).

Will fail if Loom is already running.

### `Run()`

=== "Luau"
    ```luau
    Loom.Run()
    ```

Starts all services included by [`Loom.AddSource()`](#addsource).

Will fail if Loom is already running.

### `Terminate()`

=== "Luau"
    ```luau
    Loom.Terminate()
    ```

Stops all services included by [`Loom.AddSource()`](#addsource).

Will fail if Loom is not running.

### `IsRunning()`

=== "Luau"
    ```luau
    Loom.IsRunning(): boolean
    ```

**Returns:**

- [`boolean`](https://www.lua.org/pil/2.2.html) — A value representing if Loom is running or not.

### `CreateService()`

=== "Luau"
    ```luau
    Loom.CreateService(
        table: Loom.ServiceTable
    )
    ```

**Parameters:**

- `table` [`Loom.ServiceTable`](#servicetable) — Table that you want to register as a service.

### `OnStart()`

=== "Luau"
    ```luau
    Loom.OnStart(
        service: Loom.ServiceTable,
        func: Loom.EventHandler
    )
    ```

**Parameters:**

- `service` [`Loom.ServiceTable`](#servicetable) — A table that has been marked as a service using [`Loom.CreateService`](#createservice), to which you want to attach the lifecycle event.
- `func` [`Loom.EventHandler`](#eventhandler) — A function that is going to be called when this event is triggered.

### `OnStop()`

=== "Luau"
    ```luau
    Loom.OnStop(
        service: Loom.ServiceTable,
        func: Loom.EventHandler
    )
    ```

**Parameters:**

- `service` [`Loom.ServiceTable`](#servicetable) — A table that has been marked as a service using [`Loom.CreateService`](#createservice), to which you want to attach the lifecycle event.
- `func` [`Loom.EventHandler`](#eventhandler) — A function that is going to be called when this event is triggered.

### ~~`On()`~~

=== "Luau"
    ```luau
    Loom.On(
        service: Loom.ServiceTable,
        trigger: Loom.Trigger,
        func: Loom.EventHandler
    )
    ```

**Parameters:**

- `service` [`Loom.ServiceTable`](#servicetable) — A table that has been marked as a service using [`Loom.CreateService`](#createservice), to which you want to attach the lifecycle event.
- `trigger` [`Loom.Trigger`](#trigger) — The event on which the handler function is going to be triggered.
- `func` [`Loom.EventHandler`](#eventhandler) — A function that is going to be called when this event is triggered.

???+ warning "Deprecated"
    `Loom.On()` is deprecated as of v1.1.2 and will be removed in v1.2.
    
    Use specific [`OnStart()`](#onstart) and [`OnStop()`](#onstop) functions instead.

#### ~~Triggers~~

???+ warning "Deprecated"
    Triggers are deprecated as of v1.1.2 and will be removed in v1.2.

##### ~~`Init`~~

##### ~~`Start`~~

##### ~~`Stop`~~

### ~~`IsServiceInitialized()`~~

=== "Luau"
    ```luau
    Loom.IsServiceInitialized(
        service: Loom.ServiceTable
    ): boolean
    ```

???+ warning "Deprecated"
    `Loom.IsServiceInitialized()` is deprecated as of v1.1.2 and will be removed in v1.2.

    You can initialize your modules without any library-specific code in Luau.

**Parameters:**

- `service` [`Loom.ServiceTable`](#servicetable) — A table that has been marked as a service using [`Loom.CreateService`](#createservice), to which you want to attach the lifecycle event.

**Returns:**

- [`boolean`](https://www.lua.org/pil/2.2.html) — A value representing if the given service is initialized or not.

### `IsServiceStarted()`

=== "Luau"
    ```luau
    Loom.IsServiceStarted(
        service: Loom.ServiceTable
    ): boolean
    ```

**Parameters:**

- `service` [`Loom.ServiceTable`](#servicetable) — A table that has been marked as a service using [`Loom.CreateService`](#createservice), to which you want to attach the lifecycle event.

**Returns:**

- [`boolean`](https://www.lua.org/pil/2.2.html) — A value representing if the given service is started or not.

## Exported types

### `ServiceTable`

### ~~`Trigger`~~

???+ warning "Deprecated"
    `Loom.Trigger` is deprecated as of v1.1.2 and will be removed in v1.2.
    
    Use specific [`OnStart()`](#onstart) and [`OnStop()`](#onstop) functions instead.

### `EventHandler`
