local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CacheLoader = require(ReplicatedStorage.Core.utility.CacheModule)

local ReplicationRemote = ReplicatedStorage.Core.modules.Replication.Replicate

local Cache = CacheLoader.loadModules(script)

ReplicationRemote.OnClientEvent:Connect(function(eventName, eventAction, data)
    if 
    Cache[eventName] and Cache[eventName][eventAction] and Cache[eventName][eventAction](data) then        
        Cache[eventName][eventAction](data)
    else
        warn(`{eventName} with the action: {eventAction} doesn't exists`)
    end
end)