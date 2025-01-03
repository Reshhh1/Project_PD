local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HitboxModule = require(ReplicatedStorage.Core.modules.HitboxModule)
local Config = require(script.Config)

local CooldownRemote = ReplicatedStorage.Core.remotes.isOnCooldown
local ComboCountRemote = ReplicatedStorage.Core.remotes.getComboCount
local WeaponRemotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local LocalPlayer = Players.LocalPlayer
local Animations = script.Animations

local FistController = {}
FistController.__index = FistController

FistController.WeaponName = "Fist"

function FistController.new(tool: Tool)
    local self = setmetatable({
        tool = tool,
        equipped = false,
        debounce = false
    }, FistController)
    return self
end

function FistController:equip()
	self.equipped = true
end

function FistController:unEquip()
    self.equipped = false
end

function FistController.handleUserInput(self, input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent or not self.equipped then
		return
	end
    normalAttack(self, input)
end

function FistController._addConnection(self, connection: RBXScriptConnection)
	table.insert(self.connections, connection)
end

function normalAttack(self, input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not self.debounce then
		self.debounce = true
		normalAttackRequest(self.tool)
		self.debounce = false
	end
end

function createHitbox(root: Part): HitboxModule.HitboxModel
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = { root.Parent }
	return HitboxModule.new()
		:setSize(Config.COMBAT.NORMAL_ATTACK.HITBOX_SIZE)
		:setPosition(root.CFrame * Config.COMBAT.NORMAL_ATTACK.HITBOX_OFFSET)
		:makeVisible()
		:setWeldRoot(root)
		:setOverlapParams(overlapParams)
		:build()
end

function normalAttackRequest(tool: Tool)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local isOnCooldown = CooldownRemote:InvokeServer("Basic attack")
	
	if not isOnCooldown then
		local comboCount = ComboCountRemote:InvokeServer()
		local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
		local animator = humanoid:FindFirstChild("Animator") :: Animator

		local animation = Animations[`Attack_{comboCount}`]
		local animationTrack = animator:LoadAnimation(animation)
		animationTrack:Play()
		animationTrack:AdjustSpeed(1.2)

		animationTrack:GetMarkerReachedSignal("impact"):Connect(function()
			local clientHitbox = createHitbox(humanoidRootPart)
			local result = clientHitbox:getHitResults()
			WeaponRemotes.WeaponAttack:InvokeServer({ weapon = tool, action = Config.COMBAT.NORMAL_ATTACK.NAME }, { charactersInHitbox = result})
		end)
		animationTrack.Stopped:Wait()
		task.wait(Config.COMBAT.NORMAL_ATTACK.COOLDOWNS.client[comboCount])
	end
end

return FistController