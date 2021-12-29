-- TODO: Replace comments with doc ones
-- TODO: Add tests for __mul(), __call(), __index() and __newindex() functions
local boolvalues = {
	["1"] = "0";
	["true"] = "false";
	["on"] = "off";
	["yes"] = "no";
	["y"] = "n"
}
local eschars = {
	"\"", "'", "\\"
}
local escregexchars = {
	"(", ")", ".", "%", "+", "-", "*", "?", "[", "]", "^", "$"
}
local mt = getmetatable("")

local function includes(tbl, item)
	for k, v in pairs(tbl) do
		if v == item then
			return true
		end
	end
	return false
end

--- Overloads `*` operator. Works the same as `string.rep()` function.
function mt:__mul(n)
	if type(self) == "number" then
		return n * self
	end
	if type(n) ~= "number" then
		error(string.format("attempt to mul a '%1' with a 'string'", type(n)))
	end
	return self:rep(n)
end

--- Overloads `()` operator. Works the same as `string.iter()` function.
function mt:__call()
	return self:iter()
end

-- TODO
function mt:__index(i)
end

-- TODO
function mt:__newindex(i, ch)
end

-- Splits string by supplied separator. If the `regex` parameter is set to true then the separator is considered as a regular expression
function string:split(sep, regex)
	if sep == "" then
		return self:totable()
	end
	local result = {}
	local previdx = 1
	while true do
		local startidx, endidx = self:find(sep, previdx, not regex)
		if not startidx then
			table.insert(result, self:sub(previdx))
			break
		end
		table.insert(result, self:sub(previdx, startidx - 1))
		previdx = endidx + 1
	end
	return result
end

-- Trims string's characters from its endings. Trims whitespaces by default. The `chars` argument is a regex string containing which characters to trim
function string:trim(chars)
	chars = chars or "%s"
	return self:trimstart(chars):trimend(chars)
end

-- Trims string's characters from its left side. Trims whitespaces by default. The `chars` argument is a regex string containing which characters to trim
function string:trimstart(chars)
	return self:gsub("^["..(chars or "%s").."]+", "")
end

-- Trims string's characters from its right side. Trims whitespaces by default. The `chars` argument is a regex string containing which characters to trim
function string:trimend(chars)
	return self:gsub("["..(chars or "%s").."]+$", "")
end

-- Pads string at the start with specified string until specified length. " " pad string by default
function string:padstart(len, str)
	str = str or " "
	local selflen = self:len()
	return (str:rep(math.ceil((len - selflen) / str:len()))..self):sub(-(selflen < len and len or selflen))
end

-- Pads string at the end with specified string until specified length. " " pad string by default
function string:padend(len, str)
	str = str or " "
	local selflen = self:len()
	return (self..str:rep(math.ceil((len - selflen) / str:len()))):sub(1, selflen < len and len or selflen)
end

-- If the string starts with specified prefix then returns string itself, otherwise pads the string until it starts with the prefix
function string:ensurestart(prefix)
	local prefixlen = prefix:len()
	if prefixlen > self:len() then
		return prefix:ensureend(self)
	end
	local left = self:sub(1, prefixlen)
	local i = 1
	while not prefix:endswith(left) and i <= prefixlen do
		i = i + 1
		left = left:sub(1, -2)
	end
	return prefix:sub(1, i - 1)..self
end

-- If the string ends with specified prefix then returns string itself, otherwise pads the string until it ends with the prefix
function string:ensureend(suffix)
	local suffixlen = suffix:len()
	if suffixlen > self:len() then
		return suffix:ensurestart(self)
	end
	local right = self:sub(-suffixlen)
	local i = suffixlen
	while not suffix:startswith(right) and i >= 1 do
		i = i - 1
		right = right:sub(2)
	end
	return self..suffix:sub(i + 1)
end

-- Adds backslashes before ", ' and \ characters. Escape character can be specified ("\\" by default) as well as characters to escape ({"\"", "'", "\\"} by default)
function string:esc(eschar, eschartbl)
	local result = ""
	eschar = eschar or "\\"
	eschartbl = eschartbl or eschars
	for char in self:iter() do
		result = includes(eschartbl, char) and result..eschar..char or result..char
	end
	return result
end

-- Strips backslashes from the string. Escape character can be specified ("\\" by default)
function string:unesc(eschar)
	local result = ""
	local i = 0
	eschar = eschar or "\\"
	while i <= #self do
		local char = self:sub(i, i)
		if char == eschar then
			i = i + 1
			result = result..self:sub(i, i)
		else
			result = result..char
		end
		i = i + 1
	end
	return result
end

-- Escapes pattern special characters so the can be used in pattern matching functions as is
function string:escpattern()
	return self:esc("%", escregexchars)
end

-- Unescapes pattern special characters
function string:unescpattern()
	return self:unesc("%")
end

-- Escapes regexp special characters so the can be used in regexp functions as is
--- @deprecated
function string:escregex()
	return self:esc("%", escregexchars)
end

-- Unescapes regexp special characters
--- @deprecated
function string:unescregex()
	return self:unesc("%")
end

--- Returns an iterator which can be used in for loops
function string:iter()
	local i = 0
	return function ()
		i = i + 1
		return i <= self:len() and self:sub(i, i) or nil
	end
end

--- Truncates string to a specified length with optional suffix (usually "...", nil by default)
function string:truncate(len, suffix)
	if suffix then
		local newlen = len - suffix:len()
		return 0 < newlen and newlen < self:len() and self:sub(1, newlen)..suffix or self:sub(1, len)
	else
		return self:sub(1, len)
	end
end

-- Returns true if the string starts with specified string
function string:startswith(prefix)
	return self:sub(0, prefix:len()) == prefix
end

-- Returns true if the string ends with specified string
function string:endswith(suffix)
	return self:sub(self:len() - suffix:len() + 1) == suffix
end

-- Returns true if string's length is 0
function string:isempty()
	return self:len() == 0
end

-- Returns true if string consists of whitespace characters
function string:isblank()
	return self:match("^%s*$") ~= nil
end

-- Converts "1", "true", "on", "yes", "y" and their contraries into real boolean. Returns nil if casting cannot be done. Case-insensetive
function string:tobool()
	local lowered = self:lower()
	for truthy, falsy in pairs(boolvalues) do
		if lowered == truthy then
			return true
		elseif lowered == falsy then
			return false
		end
	end
	return nil
end

-- Returns table containing all the chars in the string
function string:totable()
	local result = {}
	for ch in self:iter() do
		table.insert(result, ch)
	end
	return result
end
