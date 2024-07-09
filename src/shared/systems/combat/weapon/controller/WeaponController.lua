local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local WeaponConfigHandler = require(ReplicatedStorage.Core.systems.combat.weapon.handlers.WeaponConfigHandler)
local HitboxModule = require(ReplicatedStorage.Core.modules.HitboxModule)

local WeaponTypes = require(ReplicatedStorage.Core.systems.combat.weapon.types.WeaponTypes)

local CooldownRemote = ReplicatedStorage.Core.remotes.isOnCooldown
local WeaponRemotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local LocalPlayer = Players.LocalPlayer

local WeaponController = {}
WeaponController.__index = WeaponController

export type CombatController = typeof(setmetatable({} :: {
	tool: Tool,
	config: WeaponTypes.WeaponConfigType,
	debounce: boolean,
	equipped: boolean,
	connections: table
}, WeaponController))

function WeaponController.new(tool: Tool): CombatController
	local self = setmetatable({
		tool = tool,
		config = WeaponConfigHandler.getConfigByWeaponName(tool.Name),
		debounce = false,
		equipped = false,
		connections = {}
	}, WeaponController)
	self:init()
	return self
end

function WeaponController.init(self: CombatController)
	self:_addConnection(self.tool.Equipped:Connect(function()
		self:_equip()
	end))
	self:_addConnection(self.tool.Unequipped:Connect(function()
		self:_unEquip()
	end))
	self:_addConnection(UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		self:_attack(input, gameProcessedEvent)
	end))
end

function WeaponController._equip(self: CombatController)
	self.equipped = true
end

function WeaponController._unEquip(self: CombatController)
	self.equipped = false
end

function WeaponController._addConnection(self: CombatController, connection: RBXScriptConnection)
	table.insert(self.connections, connection)
end

function WeaponController.destroy(self: CombatController)
	self:_unEquip()
	for _, connection: RBXScriptConnection in pairs(self.connections) do
		connection:Disconnect()
	end
end

function WeaponController._attack(self: CombatController, input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent or not self.equipped then
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not self.debounce then
		self.debounce = true
		normalAttackRequest(self.tool, self.config)
		self.debounce = false
	end
end

function WeaponController._heavyAttack() end

function createHitbox(root: Part, config: WeaponTypes.WeaponConfigType): HitboxModule.HitboxModel
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

function normalAttackRequest(tool: Tool, config: WeaponTypes.WeaponConfigType)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local isOnCooldown = CooldownRemote:InvokeServer(LocalPlayer.UserId, "NormalAttack")
	if not isOnCooldown then
		local hitbox = createHitbox(humanoidRootPart, config)
		local result = hitbox:getHitResults()
		local response = WeaponRemotes.WeaponAttack:InvokeServer(tool,config.COMBAT.NORMAL_ATTACK.NAME, result)
		task.wait(config.COMBAT.NORMAL_ATTACK.COOLDOWNS)
	end
end

return WeaponController
