local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local HitboxModule = require(ReplicatedStorage.Core.modules.HitboxModule)

local Remotes = ReplicatedStorage.Core.systems.combat.weapon.remotes
local LocalPlayer = Players.LocalPlayer

local WeaponController = {}
WeaponController.__index = WeaponController

export type CombatController = typeof(setmetatable(WeaponController.new(), WeaponController))

function WeaponController.new(tool: Tool): CombatController
	local self = setmetatable({
		tool = tool,
		debounce = false,
		equipped = false,
		connections = {},
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
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			self.debounce = true
			local hitbox = createHitbox(humanoidRootPart)
			normalAttackRequest(hitbox)
		end
		task.wait(0.6)
		self.debounce = false
	end
end

function WeaponController._heavyAttack() end

function createHitbox(root: Part): HitboxModule.HitboxModel
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = { root.Parent }

	return HitboxModule.new()
		:setSize(Vector3.new(6, 6, 6))
		:setPosition(root.CFrame * CFrame.new(0,0,-3))
		:makeVisible()
		:setWeldRoot(root)
		:setOverlapParams(overlapParams)
		:build()
end

function normalAttackRequest(hitbox: HitboxModule.HitboxModel)
	local result = hitbox:getHitResults()
	local response = Remotes.NormalAttack:InvokeServer(result)
end

return WeaponController
