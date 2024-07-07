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
        if Cooldown.playerCooldowns[userId] then
            if Cooldown.playerCooldowns[userId][name] then
                Cooldown.playerCooldowns[userId][name] = nil
                if afterCooldown ~= nil then afterCooldown() end
                print("Removing", Cooldown.playerCooldowns)
            end
        end
    end)
end

return Cooldown