local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DistanceCalculator = require(ReplicatedStorage.Core.utility.DistanceCalculator)

local function validateNormalAttack(origin: Part, target: Part, allowedDistance: number)
    local isWithinDistance = DistanceCalculator.getDistanceBetween(origin, target) <= allowedDistance
    return isWithinDistance
end

return function(origin: Part, target: Part, allowedDistance: number): boolean
    return validateNormalAttack(origin, target, allowedDistance)
end