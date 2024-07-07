local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WeldModule = require(ReplicatedStorage.Core.utility.module.WeldModule)
local Constants = require(ReplicatedStorage.Core.utility.Constants)


local Hitbox = {}
Hitbox.__index = Hitbox

export type HitboxModel = typeof(setmetatable({} :: {
    cframe: CFrame,
    size: Vector3,
    overlapParams: OverlapParams | nil,
    isVisible: boolean,
    weldRoot: Part,
    hitboxPart: Part
}, Hitbox))

function Hitbox.new(): HitboxModel
    local self = setmetatable({
        cframe = CFrame.new(0,10,0),
        size = Vector3.new(0,0,0),
        overlapParams = nil,
        isVisible = false,
        weldRoot = nil,
        hitboxPart = nil
    }, Hitbox)
    return self
end

function Hitbox.setPosition(self: HitboxModel, cframe: CFrame): HitboxModel
	self.cframe = cframe
    return self
end

function Hitbox.setSize(self: HitboxModel, size: Vector3): HitboxModel
    self.size = size
    return self
end

function Hitbox.makeVisible(self: HitboxModel): HitboxModel
    self.isVisible = true
    return self
end

function Hitbox.setWeldRoot(self: HitboxModel, weldRoot: Part): HitboxModel
	self.weldRoot = weldRoot
    return self
end

function Hitbox.setOverlapParams(self: HitboxModel, overlapParam: OverlapParams): HitboxModel
    self.overlapParams = overlapParam
    return self
end

function Hitbox.getHitResults(self: HitboxModel): table
    if self.overlapParams == nil then
         warn("No overlapParams provided")
    end
    
    local results = game.Workspace:GetPartsInPart(self.hitboxPart, self.overlapParams)
    local hits = {}
    for _, result in pairs(results) do
        local enemyCharacter = result.Parent
        local enemyHumanoid = enemyCharacter:FindFirstChild("Humanoid") :: Humanoid
        if enemyHumanoid then
            if enemyHumanoid.Health > 0 and not table.find(hits, enemyCharacter) then
                table.insert(hits, enemyCharacter)
            end
        end
    end
    Debris:AddItem(self.hitboxPart, 0.5)
    return hits
end

function Hitbox.build(self: HitboxModel): HitboxModel
    local hitbox = Instance.new("Part")
    hitbox.CFrame = self.cframe
    hitbox.Size = self.size
    hitbox.Material = Enum.Material.ForceField
    hitbox.Anchored = false
    hitbox.Massless = true
    hitbox.CanCollide = false
    hitbox = setPartVisibility(hitbox, self.isVisible)
    hitbox.Parent = Constants.ENTITY_FOLDER
    setWeld(self, hitbox)
    self.hitboxPart = hitbox
    return self
end

function setPartVisibility(part: Part, isVisible): Part
    if isVisible then 
        part.Transparency = 0.5 
        part.Color = Color3.fromRGB(255, 0, 0)
    else 
        part.Transparency = 1 
    end
    return part
end

function setWeld(self: HitboxModel, hitbox: Part)
    if self.weldRoot ~= nil then
        WeldModule.createWeld(self.weldRoot, hitbox)
    end
end

return Hitbox
