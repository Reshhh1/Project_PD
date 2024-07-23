local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ComboModule = require(ServerScriptService.Core.systems.combat.modules.ComboModule)
local HitboxHandler = require(ServerScriptService.Core.handlers.HitboxHandler)
local CooldownModule = require(ServerScriptService.Core.utility.Cooldown)

local validateArguments = require(script.validateArguments)

local WeaponTypes = require(ReplicatedStorage.Core.systems.combat.weapon.types.WeaponTypes)

local BasicAttack = {}

-- Being used in the initilization of skills
BasicAttack.MoveName = "Basic attack"

function BasicAttack.init(player: Player, config: WeaponTypes.WeaponMoveType, args: any)
    if not validateArguments(args) then return end
    local charactersInHitbox = args.charactersInHitbox
    local character = player.Character
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local comboCount = ComboModule.get(character)
    print(args)
    -- local weld = Instance.new("Motor6D")
	-- 	weld.Part0 = character:FindFirstChild("Right Arm")
	-- 	weld.Part1 =  args.weapon:FindFirstChild("Handle")
	-- 	weld.C0 = CFrame.new(0,-1,0) * CFrame.Angles(math.rad(-90),0,0)
	-- 	weld.Parent = character:FindFirstChild("Right Arm")
        
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
        humanoid:TakeDamage(damage)
    end
end

return BasicAttack