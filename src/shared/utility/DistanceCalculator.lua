local DistanceCalculator = {}

function DistanceCalculator.getDistanceBetween(origin: Part, target: Part)
    return (target.Position - origin.Position).Magnitude
end

return DistanceCalculator