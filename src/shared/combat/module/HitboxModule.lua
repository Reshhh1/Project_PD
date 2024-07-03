local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WeldModule = require(ReplicatedStorage.Core.utility.module.WeldModule)
local Constants = require(ReplicatedStorage.Core.utility.Constants)

local Hitbox = {}
Hitbox.__index = Hitbox

type Hitbox = typeof(setmetatable({} :: {
    cframe: CFrame,
    size: Vector3,
    isVisible: boolean,
    overlapParams: OverlapParams?,
    weldRoot: Part?,
    hitboxPart: Part?
}, Hitbox))

function Hitbox.new(): Hitbox
    local self = setmetatable({
        cframe = CFrame.new(0,10,0),
        size = Vector3.new(5,5,5),
        overlapParams = nil,
        isVisible = false,
        weldRoot = nil,
        hitboxPart = nil
    }, Hitbox)
    return self
end

function Hitbox.setPosition(self: Hitbox, cframe: CFrame)
    self.cframe = cframe
    return self
end

function Hitbox.setSize(self: Hitbox, size: Vector3)
    self.size = size
    return self
end

function Hitbox.makeVisible(self: Hitbox)
    self.isVisible = true
    return self
end

function Hitbox.setWeldRoot(self: Hitbox, weldRoot: Part)
    self.weldRoot = weldRoot
    return self
end

function Hitbox.setOverlapParams(self: Hitbox, overlapParam: OverlapParams)
    print("Provided")
    self.overlapParams = overlapParam
    print(self)
    return self
end

function Hitbox.getHitResults(self: Hitbox)
    if self.overlapParams == nil then
         warn("No overlapParams provided")
    end
    local results = game.Workspace:GetPartsInPart(self.hitboxPart, self.overlapParams)
    for _, result in pairs(results) do
        local enemyCharacter = result.Parent
        if enemyCharacter then
            local enemyPlayer = Players:GetPlayerFromCharacter(enemyCharacter)
            local enemyHumanoid = enemyCharacter:FindFirstChild("Humanoid") :: Humanoid
            if enemyHumanoid and enemyHumanoid.Health > 0 then
                if enemyPlayer then
                    print("PLAYER")
                else
                    print("NPC")
                end
            end
        end
    end
    return results
end

function setPartVisibility(part: Part, isVisible)
    if isVisible then 
        part.Transparency = 0.85 
        part.Color = Color3.fromRGB(255, 0, 0)
    else 
        part.Transparency = 1 
    end
    return part
end

function setWeld(self: Hitbox, hitbox: Part)
    if self.weldRoot ~= nil then
        WeldModule.createWeld(self.weldRoot, hitbox)
    end
end

function Hitbox.build(self: Hitbox)
    local hitbox = Instance.new("Part")
    hitbox.CFrame = self.cframe
    hitbox.Size = self.size
    hitbox.Anchored = false
    hitbox.CanCollide = false
    hitbox = setPartVisibility(hitbox, self.isVisible)
    hitbox.Parent = Constants.ENTITY_FOLDER
    setWeld(self, hitbox)
    self.hitboxPart = hitbox
    return self
end

return Hitbox