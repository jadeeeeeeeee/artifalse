function LoopOverPlayers(callback)
	for i = 0, DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidTeamPlayer(i) then
			local player = PlayerResource:GetPlayer(i)
			callback(player)
		end
	end
end

-- 定时器
-- 在XX秒之后，执行XX操作
-- Timer(1, function() ... end)
-- Timer(function() ... end)
function Timer(delay, callback)
	if callback == nil then
		callback = delay
		delay = 0
	end

	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString('timer'),function()
		return callback()
	end,delay)
end