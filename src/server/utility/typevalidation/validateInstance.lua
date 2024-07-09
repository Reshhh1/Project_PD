local function validateInstance(instance: Instance, expectedClass: string)
	if typeof(instance) ~= "Instance" then
		return false
	end

	return instance:IsA(expectedClass)
end

return validateInstance