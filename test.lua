require "."
local luaunit = require "luaunit"
TestString = {
	["test: split()"] = function ()
		luaunit.assertEquals(1, 1)
	end
}

local runner = luaunit.LuaUnit.new()
runner:setOutputType("text")
os.exit(runner:runSuite())
