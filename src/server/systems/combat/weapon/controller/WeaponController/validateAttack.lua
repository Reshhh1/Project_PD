local ServerScriptService = game:GetService("ServerScriptService")

local CooldownModule = require(ServerScriptService.Core.utility.Cooldown)

local function validateAttack(player: Player)
    local character = player.Character
    if not character then 
        return false
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then 
        return false
    end
    if humanoid.Health < 0 then 
        return false 
    end

    local isOnCooldown = CooldownModule.isCooldownActive(player.UserId, "NormalAttack")
    if isOnCooldown then
        return false
    end
    return true
end

return validateAttack