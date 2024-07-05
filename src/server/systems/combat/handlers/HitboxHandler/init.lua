local validateDistance = require(script.validateDistance)
local validateDetectedCharacter = require(script.validateDetectedCharacter)

local HitboxHandler = {}

function HitboxHandler.handleCharactersInHitbox(origin: Part, enemyCharacter: CharacterMesh, onHit: () -> {}?)
    local isValidCharacter = validateDetectedCharacter(enemyCharacter)
    if isValidCharacter then
        local enemyRootPart = enemyCharacter:FindFirstChild("HumanoidRootPart")
        if enemyRootPart then
            local inAllowedDistance = validateDistance(origin, enemyRootPart)
            if inAllowedDistance then
                if onHit ~= nil then  onHit() end
            end
        end
    end
end

return HitboxHandler