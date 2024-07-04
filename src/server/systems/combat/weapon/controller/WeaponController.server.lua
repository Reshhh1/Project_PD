local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Core.systems.combat.weapon.remotes 

local response = function(player: Player, ...): any
	print(...)
	return ...
end

Remotes.NormalAttack.OnServerInvoke = response

