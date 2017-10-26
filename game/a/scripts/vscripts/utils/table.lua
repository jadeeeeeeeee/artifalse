function table.count(tbl)
	local c = 0
	for _ in pairs(t) do
		c = c + 1
	end
	return c
end

function table.random(tbl)
	-- 在一个table里面，随机取一个值
	local key_table = {} -- 绝对是一个hash表
	for k in pairs(tbl) do
		table.insert(key_table, k) -- 把键存入到table中去
	end

	local rand = key_table[RandomInt(1,#key_table)]

	return tbl[rand]
end

function table.contains(tbl, val)
	for _, v in pairs(tbl) do
		if v == val then
			return true
		end
	end
end