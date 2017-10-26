-- 动态类型语言
-- 变量类型 number string boolean table function userdata
-- 循环与迭代器 while repeat for
-- 迭代器 = 循环遍历一个table的方法 pairs ipairs
-- 流程控制 if
-- 函数
-- require机制

require 'utils.table'
require 'api.CDOTAPlayer'

require 'modules.round_manager'

function Activate()

	GameRules.vAllPlayers = {} -- 储存所有的玩家

	require 'utils.funcs'
end

function Precache(context)
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end