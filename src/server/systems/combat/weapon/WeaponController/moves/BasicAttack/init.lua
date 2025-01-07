local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ComboModule = require(ServerScriptService.Core.systems.combat.modules.ComboModule)
local HitboxHandler = require(ServerScriptService.Core.handlers.HitboxHandler)
local CooldownModule = require(ServerScriptService.Core.utility.Cooldown)

local validateArguments = require(script.validateArguments)

local WeaponTypes = require(ReplicatedStorage.Core.systems.combat.weapon.types.WeaponTypes)

local BasicAttack = {}

function BasicAttack.init(player: Player, config: WeaponTypes.WeaponMoveType, args: any)
    if not validateArguments(args) then return end
    local charactersInHitbox = args.charactersInHitbox
    local character = player.Character
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local comboCount = ComboModule.get(character)
        
	if humanoidRootPart then
		for _, targetCharacter in pairs(charactersInHitbox) do
			HitboxHandler.handleCharactersInHitbox(humanoidRootPart, targetCharacter, function()  onHit(targetCharacter, config.BASE_DAMAGE[comboCount]) end)
		end
	end
    CooldownModule
        .new(player.UserId, config.NAME, config.COOLDOWNS.server[comboCount])
        :create()
    ComboModule.update(character, 5)
end

function onHit(character: CharacterMesh, damage: number)
    local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
    if humanoid then
        humanoid:TakeDamage(damage)
    end
end

return BasicAttack