# Getting started

This tutorial provides a basic example of using Loom.

We are going to write a simple service that is going to log players that connect and disconnect from the server.

## Writing the server script

???+ tip "Automatic module loading"
    Loom can detect and load it's services automatically.
    
    That means that if you reference an [`Instance`](https://create.roblox.com/docs/reference/engine/classes/Instance) when calling [`Loom.AddSource()`](../api-reference/loom.md#addsource), it is going to loop through all child instances, and load all found [`ModuleScripts`](https://create.roblox.com/docs/reference/engine/classes/ModuleScript) as loom services.

=== "Luau"

    ```luau
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local ServerScriptService = game:GetService("ServerScriptService")
    local Loom = require(ReplicatedStorage.Packages.Loom)

    Loom.AddSource(ServerScriptService:WaitForChild("Services"))

    Loom.Run()

    game:BindToClose(Loom.Terminate)
    ```

## Registering the service

Now, let's create a basic service. You might have noticed that in the server script, I have added the `ServerScriptService.Services` folder as a source. That means that all [`ModuleScripts`](https://create.roblox.com/docs/reference/engine/classes/ModuleScript) under that folder are going to be loaded by Loom. That's why I am creating a `PlayerLogService` under `ServerScriptService.Services`.

=== "Luau"

    ```luau
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Loom = require(ReplicatedStorage.Packages.Loom)

    local PlayerLogService = {}

    Loom.CreateService(PlayerLogService)

    return PlayerLogService
    ```

As you can see, we have to mark our table as a Loom service. That is going to allow us to add lifecycle events and load this module automatically.

## Writing the service functions

We are going to write the service functions just like we would in a normal codebase

=== "Luau"

    ```luau
    --- ...

    function PlayerLogService.LogPlayerAdded(player: Player)
        print(player.Name.." has joined the game")
    end

    function PlayerLogService.LogPlayerRemoving(player: Player)
        print(player.Name.." has left the game")
    end

    --- ...
    ```

## Writing the service lifecycle

To add the service lifecycle, we are going to use Loom functions that act as annotations for our module.

=== "Luau"

    ```luau
    Loom.OnStart(PlayerLogService, function()
        print("PlayerLogService has started!")
    end)

    Loom.OnStop(PlayerLogService, function()
        print("PlayerLogService has stopped!")
    end)
    ```

## Connecting and cleaning up events

Now, let's conenct our functions to our events, and make sure that we don't forget the cleanup logic to allow us to start and stop services dynamically

=== "Luau"

    ```luau
    local PlayerLogService = {}

    PlayerLogService.PlayerAdded = nil :: RBXScriptConnection?
    PlayerLogService.PlayerRemoving = nil :: RBXScriptConnection?

    -- ...

    Loom.OnStart(PlayerLogService, function()
        PlayerLogService.PlayerAdded = Players.PlayerAdded:Connect(PlayerLogService.LogPlayerAdded)
        PlayerLogService.PlayerRemoving = Players.PlayerRemoving:Connect(PlayerLogService.LogPlayerRemoving)

        print("PlayerLogService has started!")
    end)

    Loom.OnStop(PlayerLogService, function()
        if PlayerLogService.PlayerAdded then
            PlayerLogService.PlayerAdded:Disconnect()
        end
        
        if PlayerLogService.PlayerRemoving then
            PlayerLogService.PlayerRemoving:Disconnect()
        end
        
        print("PlayerLogService has stopped!")
    end)

    -- ...
    ```

Finally, let's launch our game, and take a look at the output

```
19:43:13.296  PlayerLogService has initialized!  -  Server - PlayerLogService:14
19:43:13.296  PlayerLogService has started!  -  Server - PlayerLogService:21
19:43:13.371  wireofparadise has joined the game  -  Server - PlayerLogService:37
19:43:23.474  wireofparadise has left the game  -  Server - PlayerLogService:41
19:43:23.474  PlayerLogService has stopped!  -  Server - PlayerLogService:33
```

As you can see, everything works correctly:

- Our service is initialized
- Our service is started
- My character joins the game
- My character leaves the game, forcing the server to stop
- Server closes and stops all services subsequently

Now you should be able to write your own services, good luck!
