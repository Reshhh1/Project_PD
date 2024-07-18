local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WeaponConfigHandler = require(ReplicatedStorage.Core.systems.combat.weapon.handlers.WeaponConfigHandler)
local CacheModule = require(ReplicatedStorage.Core.utility.CacheModule)
local validateArguments = require(script.validation.validateArguments)
local validateAttack = require(script.validation.validateAttack)

local WeaponTypes = require(ReplicatedStorage.Core.systems.combat.weapon.types.WeaponTypes)

local Remotes = ReplicatedStorage.Core.systems.combat.weapon.remotes

local MovesModules = CacheModule.loadModules(script.moves, "MoveName")

local function initializeSkill(player: Player, action: string, config: WeaponTypes.WeaponMoveType, args: table)
	local moveModule = MovesModules[action]
	if moveModule and moveModule.init then
		moveModule.init(player, config, args)
	else
		warn(`Action: {action}. Doesn't exists`)
	end
end

Remotes.WeaponAttack.OnServerInvoke = function(player: Player, weaponAction: WeaponTypes.WeaponAction, args: {}): any
	if not validateArguments(weaponAction, args) then return end
	if not validateAttack(weaponAction.weapon, player, weaponAction.action) then return end
	
	local config = WeaponConfigHandler.getCombatMoveConfig(weaponAction.weapon.Name, weaponAction.action)
	if not config then return end

	initializeSkill(player, weaponAction.action, config, args)
end
