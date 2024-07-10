local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Red = require(ReplicatedStorage.packages.Red)

local Check = require(ReplicatedStorage.packages.guard)
return Red.Event("Nice event", function(): any
    return "e"
end)

