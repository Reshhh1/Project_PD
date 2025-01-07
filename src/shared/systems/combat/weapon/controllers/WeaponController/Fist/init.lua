local FistController = {}
FistController.__index = FistController

function FistController.new(tool: Tool)
    local self = setmetatable({
        tool = tool,
        equipped = false
    }, FistController)
    return self
end

function FistController:equip()
	self.equipped = true
end

function FistController:unEquip()
    self.equipped = false
end

function FistController.handleUserInput(self, input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent or not self.equipped then
		return
	end

end

return FistController