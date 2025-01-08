local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DistanceCalculator = require(ReplicatedStorage.Core.utility.DistanceCalculator)

local ReplicateRemote = script.Parent.Replicate

local module = {}

function module.replicateToClients(
    eventName: string,
    eventAction: string,
    origin: Vector3,
    maxDistance: number,
    data: table
)
    for _, player in pairs(Players:GetPlayers()) do
        local targetCharacter = player.Character or player.CharacterAdded:Wait()
        local targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")

        local isValidDistance = DistanceCalculator.getDistanceBetween(origin, targetHumanoidRootPart) <= maxDistance
        if isValidDistance then
            ReplicateRemote:FireClient(player, eventName, eventAction, data)
        end
    end
end

return module