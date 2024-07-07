local Players = game:GetService("Players")

local Cooldown = {}
Cooldown.__index = Cooldown

Cooldown.playerCooldowns = {}

export type CooldownModel = typeof(setmetatable({} :: {
    userId: number,
    name: string,
    length: number,
    afterCooldown: () -> any
}, Cooldown))

function Cooldown.new(userId: number, action: string, cooldownInSeconds: number): CooldownModel
    local self = setmetatable({
        userId = userId,
        name = action,
        length = cooldownInSeconds,
        afterCooldown = nil
    }, Cooldown)
    
    return self
end

function Cooldown.create(self: CooldownModel): CooldownModel
    if not Cooldown.playerCooldowns[self.userId] then Cooldown.playerCooldowns[self.userId] = {} end
    if not table.find(Cooldown.playerCooldowns[self.userId], self.name) then
        Cooldown.playerCooldowns[self.userId][self.name] = true
    end    
    scheduleCooldownRemoval(self.userId, self.name, self.length, self.afterCooldown)
    return self
end

function Cooldown.isCooldownActive(userId: number, name: string)
    local userCooldowns = Cooldown.playerCooldowns[userId]
    if userCooldowns and userCooldowns[name] then
        return true
    end
    return false   
end

--[[
    Could only be done before creating the cooldown 
    @author Reshwan
--]]
function Cooldown.aferCooldown(self: CooldownModel, afterCooldown: () -> any)
    self.afterCooldown = afterCooldown
    return self
end

function scheduleCooldownRemoval(userId: number, name: string, cooldownInSeconds: number, afterCooldown)
    task.delay(cooldownInSeconds, function()
        removeCooldown(userId, name, afterCooldown)
    end)
end

function removeCooldown(userId: number, name: string, callback: () -> any)
    local userCooldowns = Cooldown.playerCooldowns[userId]
    if not userCooldowns then return end
    
    if userCooldowns[name] then
        userCooldowns[name] = nil
        if callback ~= nil then callback() end
    end
end

function removeAllPlayerCooldowns(userId: number)
    local userCooldowns = Cooldown.playerCooldowns[userId]
    if not userCooldowns then return end

    Cooldown.playerCooldowns[userId] = nil
end

Players.PlayerRemoving:Connect(function(player)
    removeAllPlayerCooldowns(player.UserId)
end)

return Cooldown