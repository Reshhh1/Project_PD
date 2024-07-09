local ServerScriptService = game:GetService("ServerScriptService")

local validateInstance = require(ServerScriptService.Core.utility.typevalidation.validateInstance)

local function validateArguments(weapon: Tool, charactersInHitbox: { CharacterMesh }): boolean
    if typeof(charactersInHitbox) ~= "table" then
        return false
    end
    
    if not validateInstance(weapon, "Tool") then
        return false
    end
    return true
end

return validateArguments