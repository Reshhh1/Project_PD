local ServerScriptService = game:GetService("ServerScriptService")

local CooldownModule = require(ServerScriptService.Core.utility.Cooldown)

local function validateAttack(weapon: Tool, player: Player, action: string)
    local character = player.Character
    if not character then 
        return false
    end

    if weapon.Parent ~= character then
        return false
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then 
        return false
    end
    if humanoid.Health < 0 then 
        return false 
    end
   
    
    if CooldownModule.isCooldownActive(player.UserId, action) then
        return false
    end
    return true
end

return validateAttack