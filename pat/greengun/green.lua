function init()
	if effect.sourceEntity() ~= entity.id() then
		effect.setParentDirectives("setcolor="..config.getParameter("color", "0f0"))
		script.setUpdateDelta(0)
		effect.modifyDuration(math.huge)
	else
		effect.expire()
	end
end
