local validateDistance = require(script.validateDistance)
local validateDetectedCharacter = require(script.validateDetectedCharacter)

local HitboxHandler = {}

function HitboxHandler.handleCharactersInHitbox(origin: Part, enemyCharacter: CharacterMesh, onHit: () -> {}?)
    if not validateDetectedCharacter(enemyCharacter) then
        return 
    end
    local enemyRootPart = enemyCharacter:FindFirstChild("HumanoidRootPart")
    if enemyRootPart then
        if not validateDistance(origin, enemyRootPart, 10) then --HARD CODED FOR NOW
            return 
        end
        if onHit ~= nil then  onHit() end
    end
end

return HitboxHandler