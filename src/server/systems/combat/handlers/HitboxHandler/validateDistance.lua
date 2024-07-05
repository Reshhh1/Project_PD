local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DistanceCalculator = require(ReplicatedStorage.Core.utility.DistanceCalculator)

local function validateNormalAttack(origin: Part, target: Part)
    local isWithinDistance = DistanceCalculator.getDistanceBetween(origin, target) <= 10
    return isWithinDistance
end

return function(origin: Part, target: Part): boolean
    return validateNormalAttack(origin, target)
end