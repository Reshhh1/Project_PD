local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local TechniqueController = require(script.Parent.TechniqueController)
local CacheModule = require(ReplicatedStorage.Core.utility.CacheModule)

local WeaponModules = CacheModule.loadModules(script)

local WeaponController = {}
WeaponController.__index = WeaponController

export type CombatController = typeof(setmetatable(
	{} :: {
		tool: Tool,
		connections: {} ,
		toolController: any
	},
	WeaponController
))

function WeaponController.new(tool: Tool, weaponName: string): CombatController
	local self = setmetatable({
		tool = tool,
		toolController = WeaponModules[weaponName].new(tool),
		techniqueController = TechniqueController.new(tool),
		connections = {},
	}, WeaponController)
	self:init()
	return self
end

function WeaponController.init(self: CombatController)
	self:_addConnection(self.tool.Equipped:Connect(function()
		self.toolController:equip()
	end))
	self:_addConnection(self.tool.Unequipped:Connect(function()
		self.toolController:unEquip()
	end))
	self:_addConnection(UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		self.toolController:handleUserInput(input, gameProcessedEvent)
		self.techniqueController.handleUserInput(self, input, gameProcessedEvent)
	end))
end

function WeaponController._addConnection(self: CombatController, connection: RBXScriptConnection)
	table.insert(self.connections, connection)
end

return WeaponController
