local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WeaponConfigHandler = require(ReplicatedStorage.Core.systems.combat.weapon.handlers.WeaponConfigHandler)
local validateArguments = require(script.validation.validateArguments)
local validateAttack = require(script.validation.validateAttack)

local WeaponTypes = require(ReplicatedStorage.Core.systems.combat.weapon.types.WeaponTypes)

local Remotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local MovesModules = {}
for _, module in pairs(script.moves:GetChildren()) do
	if not module:IsA("ModuleScript") then continue end
	local requiredModule = require(module)
	if requiredModule.MoveName then
		MovesModules[requiredModule.MoveName] = requiredModule
	end
end

local function initializeSkill(player: Player, action: string, config: WeaponTypes.WeaponMoveType, args: table)
	local moveModule = MovesModules[action]
	if moveModule and moveModule.init then
		moveModule.init(player, config, args)
	end
end

Remotes.WeaponAttack.OnServerInvoke = function(player: Player, weaponAction: WeaponTypes.WeaponAction, args: {}): any
	if not validateArguments(weaponAction, args) then return end
	if not validateAttack(weaponAction.weapon, player, weaponAction.action) then return end
	
	local config = WeaponConfigHandler.getCombatMoveConfig(weaponAction.weapon.Name, weaponAction.action)
	if not config then return end

	initializeSkill(player, weaponAction.action, config, args)
end
