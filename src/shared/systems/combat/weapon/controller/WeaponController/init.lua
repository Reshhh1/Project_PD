local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local CacheModule = require(ReplicatedStorage.Core.utility.CacheModule)

local WeaponModules = CacheModule.loadModulesByPropertyName(script, "WeaponName")

local WeaponController = {}
WeaponController.__index = WeaponController

export type CombatController = typeof(setmetatable(
	{} :: {
		tool: Tool,
		connections: table,
		controller: any
	},
	WeaponController
))

function WeaponController.new(tool: Tool, weaponName: string): CombatController
	local self = setmetatable({
		tool = tool,
		controller = WeaponModules[weaponName].new(tool),
		connections = {},
	}, WeaponController)
	self:init()
	return self
end

function WeaponController.init(self: CombatController)
	self:_addConnection(self.tool.Equipped:Connect(function()
		self.controller:equip()
	end))
	self:_addConnection(self.tool.Unequipped:Connect(function()
		self.controller:unEquip()
	end))
	self:_addConnection(UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		self.controller:handleUserInput(input, gameProcessedEvent)
	end))
end

function WeaponController._addConnection(self: CombatController, connection: RBXScriptConnection)
	table.insert(self.connections, connection)
end

return WeaponController
