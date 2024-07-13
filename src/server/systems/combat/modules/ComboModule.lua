local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ComboRemote = ReplicatedStorage.Core.remotes.getComboCount

local ComboModule = {}

function ComboModule.get(character: Model) 
    local comboCount = getComboCount(character)
    if not comboCount then 
        setComboCount(character, 1)
        return 1
    end
    return comboCount
end

function ComboModule.update(character: Model, maxComboCount)
    local comboCount = ComboModule.get(character)
    setComboCount(character, (comboCount % maxComboCount) + 1)
    setLastAttack(character, os.clock())
end

function ComboModule.getCurrentCombo(character: Model)
    local lastAttack = getLastAttack(character)
    if lastAttack == nil then return ComboModule.get(character) end
    if os.clock() > (lastAttack + 2 ) then
        setComboCount(character, 1)
        return 1
    else
        return ComboModule.get(character)
    end
end

function getComboCount(character: Model)
    return character:GetAttribute("ComboCount")
end

function setComboCount(character: Model, count: number)
    character:SetAttribute("ComboCount", count)    
end

function getLastAttack(character: Model)
    return character:GetAttribute("LastAttack")    
end

function setLastAttack(character: Model, time)
    character:SetAttribute("LastAttack", time)    
end

function setupRemotes()
    ComboRemote.OnServerInvoke = function(player: Player): any
        local character = player.Character
        return ComboModule.getCurrentCombo(character)
    end
end

setupRemotes()

return ComboModule 