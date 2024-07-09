local WeldModule = {}

function WeldModule.createWeld(part0: Part, part1: Part)
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = part0
	weld.Part1 = part1
	weld.Parent = part1
	return weld	
end

return WeldModule