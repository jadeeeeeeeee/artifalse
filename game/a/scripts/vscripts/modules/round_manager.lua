-- 游戏流程
-- 1. 开始
-- 在游戏开始的时候，双方玩家从牌库中抽取6张牌，并执行Mulligan操作。
-- 从双方玩家中随机选择一个来作为先手玩家。
-- 2. 回合
-- 双方玩家按先手-后手的顺序来进行自己的回合内操作。
-- 每个玩家在自己的回合开始的时候，从自己的Deck中抽一张牌。
-- 每个玩家在自己的回合开始的时候，获得1点魔法值上限。
-- 玩家在自己的回合阶段，可以使用魔法值来使用卡牌以召唤生物、制造陷阱、释放魔法，也可以消耗场上生物的移动力来移动生物。
-- 玩家在点击回合结束，或者回合时间耗尽的时候，进入下一阶段。
-- 双方玩家的回合都结束的时候，进入战斗阶段。
-- 3. 战斗
-- 在战斗开始的时候，双方生物自动根据自己的AI来执行操作，玩家无法干预，但是能消耗魔法值来使用可以在战斗阶段使用的卡牌。
-- 战斗持续一段时间后结束，在战斗结束的时候，双方生物回到战斗阶段开始的状态，进入下一个回合的开始阶段。
-- 4. 胜负
-- 在某一方基地血量降为0的时候，另一方获胜。

MULLIGAN_TIME_LIMIT = 60 -- 调度时间限制

ROUND_STATE_MULLIGAN = 1 -- 调度阶段
ROUND_STATE_PLAYING = 2 -- 回合内操作阶段
ROUND_STATE_FIGHTING = 3 -- 战斗阶段

RoundManager = class({})

function RoundManager:constructor()
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(RoundManager, "OnGameRulesStateChanged"), self) -- 注册事件监听器 - 监听游戏事件改变
end

function RoundManager:OnGameRulesStateChanged()
	-- 当游戏阶段改变的时候

	print("GameRules->StateChanged CurrentState =", GameRules:State_Get())

	-- 如果当前的游戏阶段是 pre game 的话
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then

		print("pre game state")

		-- 定义一个每秒执行一次的倒数计时器
		Timer(function()
			self:OnTimer()
			return 1
		end)

		-- 在所有的玩家中循环
		LoopOverPlayers(function(player)

			-- 玩家抽 INITIAL_CARDS_COUNT 张牌
			player:DrawCards(INITIAL_CARDS_COUNT)

			-- 进入调度阶段
			self:StartMulligan()
		end)
	end
end

function RoundManager:OnTimer()

	print('timer tick....')

	if self.nCountDownTimer then
		self.nCountDownTimer = self.nCountDownTimer - 1
	end

	-- 调度阶段的计时器
	if self.nCurrentState == ROUND_STATE_MULLIGAN and self.nCountDownTimer <= 0 then
		self:StartPlaying() -- 强制停止调度阶段，进入游戏阶段
	end

	-- 显示计时器
	if self.nCountDownTimer then
		CustomGameEventManager:Send_ServerToAllClients("timer",{value = self.nCountDownTimer}) -- @todo 在UI上显示计时器
	end

	-- 在所有玩家中循环
	LoopOverPlayers(function(player)
		-- 如果GameRules.vAllPlayers不包含player的话，那么
		if not table.contains(GameRules.vAllPlayers, player) then
			-- 把player加入GameRules.vAllPlayers表
			table.insert(GameRules.vAllPlayers, player)
		end
	end)
end

-- 调度阶段
function RoundManager:StartMulligan()
	print("player start mulligan")
	self.nCountDownTimer = MULLIGAN_TIME_LIMIT -- 设置调度时间限制
	LoopOverPlayers(function(player)
		player:DoMulligan()
	end)

	self.nCurrentState = ROUND_STATE_MULLIGAN
end


-- 游戏阶段
function RoundManager:StartPlaying()
	print("game state now entering playing state")

	self.vActivatePlayer = table.random(GameRules.vAllPlayers)

	self.nCurrentState = ROUND_STATE_PLAYING
end

GameRules.RoundManager = RoundManager()