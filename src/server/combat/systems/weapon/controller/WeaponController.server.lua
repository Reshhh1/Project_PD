local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Core.combat.systems.weapon.remotes 

local response = function(player: Player, ...): any
	print(...)
	return ...
end

Remotes.NormalAttack.OnServerInvoke = response

