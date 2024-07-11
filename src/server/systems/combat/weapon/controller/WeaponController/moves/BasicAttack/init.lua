local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ComboModule = require(ServerScriptService.Core.systems.combat.modules.ComboModule)
local HitboxHandler = require(ServerScriptService.Core.handlers.HitboxHandler)
local CooldownModule = require(ServerScriptService.Core.utility.Cooldown)

local WeaponTypes = require(ReplicatedStorage.Core.systems.combat.weapon.types.WeaponTypes)

local BasicAttack = {}

BasicAttack.MoveName = "Basic attack"

function BasicAttack.init(player: Player, charactersInHitbox, config: WeaponTypes.WeaponMoveType)
    local character = player.Character
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local comboCount = ComboModule.get(character)
    
    print("SLAAT")
	if humanoidRootPart then
		for _, targetCharacter in pairs(charactersInHitbox) do
			HitboxHandler.handleCharactersInHitbox(humanoidRootPart, targetCharacter, function()  onHit(targetCharacter, config.BASE_DAMAGE[comboCount]) end)
		end
	end
    CooldownModule
        .new(player.UserId, config.NAME, config.COOLDOWNS[comboCount])
        :create()
    ComboModule.update(character, 5)
end

function onHit(character: CharacterMesh, damage: number)
    local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
    if humanoid then
        print(damage)
        humanoid:TakeDamage(damage)
    end
end

return BasicAttack