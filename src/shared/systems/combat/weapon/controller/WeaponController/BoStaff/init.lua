local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WeaponConfigHandler = require(ReplicatedStorage.Core.systems.combat.weapon.handlers.WeaponConfigHandler)
local HitboxModule = require(ReplicatedStorage.Core.modules.HitboxModule)

local CooldownRemote = ReplicatedStorage.Core.remotes.isOnCooldown
local ComboCountRemote = ReplicatedStorage.Core.remotes.getComboCount
local WeaponRemotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local LocalPlayer = Players.LocalPlayer
local Animations = script.animations

local BoStaff = {}
BoStaff.__index = BoStaff

BoStaff.WeaponName = "Bo Staff"

function BoStaff.new(tool: Tool)
    local self = setmetatable({
        tool = tool,
        config = WeaponConfigHandler.getConfigByWeaponName(BoStaff.WeaponName),
        equipped = false,
        debounce = false,
        connections = {}
    }, BoStaff)
    return self
end

function BoStaff:equip()
	self.equipped = true
end

function BoStaff:unEquip()
    self.equipped = false
end

function BoStaff.handleUserInput(self, input: InputObject, gameProcessedEvent: boolean)
    normalAttack(self, input, gameProcessedEvent)
end

function BoStaff._addConnection(self, connection: RBXScriptConnection)
	table.insert(self.connections, connection)
end

function normalAttack(self, input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent or not self.equipped then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 and not self.debounce then
		self.debounce = true
		normalAttackRequest(self.tool, self.config)
		self.debounce = false
	end
end

function createHitbox(root: Part, config): HitboxModule.HitboxModel
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = { root.Parent }

	return HitboxModule.new()
		:setSize(config.COMBAT.NORMAL_ATTACK.HITBOX_SIZE)
		:setPosition(root.CFrame * config.COMBAT.NORMAL_ATTACK.HITBOX_OFFSET)
		:makeVisible()
		:setWeldRoot(root)
		:setOverlapParams(overlapParams)
		:build()
end

function normalAttackRequest(tool: Tool, config)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local isOnCooldown = CooldownRemote:InvokeServer("Basic attack")
	local comboCount = ComboCountRemote:InvokeServer()
	if not isOnCooldown then
		print(comboCount)
		print("REAL: ", character:GetAttribute("ComboCount"))
		local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
		local animator = humanoid:FindFirstChild("Animator") :: Animator

		local animation = Animations[`Attack_{comboCount}`]:Clone()
		local animationTrack = animator:LoadAnimation(animation)
		animationTrack:Play()
		local hitbox = createHitbox(humanoidRootPart, config)
		local result = hitbox:getHitResults()
		local response =
			WeaponRemotes.WeaponAttack:InvokeServer({ weapon = tool, action = config.COMBAT.NORMAL_ATTACK.NAME }, { charactersInHitbox = result})
		task.wait(config.COMBAT.NORMAL_ATTACK.COOLDOWNS[comboCount])
	end
end

return BoStaff