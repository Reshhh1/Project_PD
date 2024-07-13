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
end

function getComboCount(character: Model)
    return character:GetAttribute("ComboCount")
end

function setComboCount(character: Model, count: number)
    character:SetAttribute("ComboCount", count)    
end

return ComboModule 