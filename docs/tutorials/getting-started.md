# Getting started

This tutorial provides a basic example of using Loom.

We are going to write a simple service that is going to log players that connect and disconnect from the server.

## Project structure

```
ServerScriptService
├── Services
│ └── PlayerLogService
└── ServerStart
```

`Services` is a [`Folder`](https://create.roblox.com/docs/reference/engine/classes/Folder)

`PlayerLogService` is a [`ModuleScript`](https://create.roblox.com/docs/reference/engine/classes/ModuleScript)

`ServerStart` is a [`Script`](https://create.roblox.com/docs/reference/engine/classes/Script)

## Preparing the server

???+ tip "Automatic module loading"
    Loom can detect and load it's services automatically.
    
    That means that if you reference an [`Instance`](https://create.roblox.com/docs/reference/engine/classes/Instance) when calling [`Loom.AddSource()`](../api-reference/loom.md#addsource), it is going to loop through all child instances, and load all [`ModuleScripts`](https://create.roblox.com/docs/reference/engine/classes/ModuleScript) that return a [`Loom.Service`](../api-reference/service.md)

=== "Luau"

    ```luau
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local ServerScriptService = game:GetService("ServerScriptService")
    local Loom = require(ReplicatedStorage.Packages.Loom)

    Loom.AddSource(ServerScriptService:WaitForChild("Services"))

    Loom.Start()

    game:BindToClose(Loom.Stop)
    ```

## Writing the service

Now, under the `Services` [`Folder`](https://create.roblox.com/docs/reference/engine/classes/Folder), create a [`ModuleScript`](https://create.roblox.com/docs/reference/engine/classes/ModuleScript) named `PlayerLogService`

=== "Luau"

    ```luau
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Loom = require(ReplicatedStorage.Packages.Loom)

    export type PlayerLogService = Loom.Service & {
        LogPlayerJoin: (self: PlayerLogService, player: Player) -> (),
        LogPlayerQuit: (self: PlayerLogService, player: Player) -> (),
    }

    local PlayerLogService: PlayerLogService = Loom.CreateService()

    function PlayerLogService:OnStart()
        print("PlayerLogService has started")
    end

    function PlayerLogService:OnStop()
        print("PlayerLogService has stopped")
    end

    return PlayerLogService
    ```

As you can see, here we have a custom [type declaration](https://luau.org/types/) that extends the [`Loom.Service`](../api-reference/service.md). This is very useful because it allows your language server to display available methods to call.

Implementing this method is not as simple as writing a function such as [`Service:OnStart()`](../api-reference/service.md#onstart) though.

We have to use a designated [`Service:AddMethod()`](../api-reference/service.md#addmethod) method.

=== "Luau"

    ```luau
    PlayerLogService:AddMethod("LogPlayerJoin", function(self: PlayerLogService, player: Player)
        print(player.Name .. " has joined the server")
    end)

    PlayerLogService:AddMethod("LogPlayerQuit", function(self: PlayerLogService, player: Player)
        print(player.Name .. " has left the server")
    end)
    ```

Now, other scripts can call it like a regular method:

=== "Luau"

    ```luau
    local ServerScriptService = game:GetService("ServerScriptService")
    local PlayerLogService = require(ServerScriptService.Services.PlayerLogService)

    PlayerLogService:LogPlayerJoin(...)
    ```

!!! note
    Loom will automatically detect and reject this call if the service has not been started yet.

Now, we have the logging methods, but they are not connected to any events. So we will adjust our type to include the event, and set the values when [`Service:OnStart()`](../api-reference/service.md#onstart) is called.

=== "Luau"

    ```luau
    -- ...
    local Players = game:GetService("Players")
    
    export type PlayerLogService = Loom.Service & {
        PlayerAddedEvent: RBXScriptConnection?,
        PlayerRemovingEvent: RBXScriptConnection?,

        --- ...
    }

    -- ...

    function PlayerLogService:OnStart()
        self.PlayerAddedEvent = Players.PlayerAdded:Connect(function(player)
            self:LogPlayerJoin(player)
        end)

        self.PlayerRemovingEvent = Players.PlayerRemoving:Connect(function(player)
            self:LogPlayerQuit(player)
        end)

        print("PlayerLogService has started")
    end
    ```

But wait! That's not the end of it. You may have noticed that I have marked these connections as [`RBXScriptConnection`](https://create.roblox.com/docs/reference/engine/datatypes/RBXScriptConnection) or [`nil`](https://www.lua.org/pil/2.1.html).

That's because these connections are [`nil`](https://www.lua.org/pil/2.1.html), when the service is not started, so we also have to clean our events up:


=== "Luau"

    ```luau
    function PlayerLogService:OnStop()
        if self.PlayerAddedEvent ~= nil then
            self.PlayerAddedEvent:Disconnect()
        end

        if self.PlayerRemovingEvent ~= nil then
            self.PlayerRemovingEvent:Disconnect()
        end

        print("PlayerLogService has stopped")
    end
    ```

Now, let's join the server, then disconnect and stop the server, and look at the output:

```
17:29:00.307  PlayerLogService has started  -  Server - PlayerLogService:23
17:29:00.385  wireofparadise has joined the server  -  Server - PlayerLogService:39
17:29:02.509  Disconnect from 127.0.0.1|55600  -  Studio
17:29:02.510  wireofparadise has left the server  -  Server - PlayerLogService:43
17:29:10.486  PlayerLogService has stopped  -  Server - PlayerLogService:35
```

And as you can see, our `PlayerLogService` has successfully started, performed it's task, and when the server stopped, it has stopped the PlayerLogService with it.
