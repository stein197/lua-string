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
--- @param n number Multiplier.
--- @return string rs String multiplied `n` times.
function mt:__mul(n)
	if type(self) == "number" then
		return n * self
	end
	if type(n) ~= "number" then
		error(string.format("attempt to mul a '%1' with a 'string'", type(n)))
	end
	return self:rep(n)
end

--- Overloads `[]` operator. It's possible to access individual chars with this operator. Index could be negative. In
--- that case the counting will start from the end.
--- @param i number Index at which retrieve a char.
--- @return string|nil ch Single character at specified index. Nil if the index is larger than length of the string.
function mt:__index(i)
	if string[i] then
		return string[i]
	end
	i = i < 0 and #self + i + 1 or i
	local rs = self:sub(i, i)
	return #rs > 0 and rs or nil
end

--- Splits the string by supplied separator. If the `pattern` parameter is set to true then the separator is considered
--- as a pattern.
--- @param sep string Separator by which separate the string.
--- @param pattern? boolean `true` for separator to be considered as a pattern. `false` by default.
--- @return string[] t Table of substrings separated by `sep` string.
function string:split(sep, pattern)
	if sep == "" then
		return self:totable()
	end
	local rs = {}
	local previdx = 1
	while true do
		local startidx, endidx = self:find(sep, previdx, not pattern)
		if not startidx then
			table.insert(rs, self:sub(previdx))
			break
		end
		table.insert(rs, self:sub(previdx, startidx - 1))
		previdx = endidx + 1
	end
	return rs
end

--- Trims string's characters from its endings. Trims whitespaces by default. The `chars` argument is a pattern
--- containing which characters to trim.
--- @param chars? string Pattern that represents which characters to trim from the ends. Whitespaces by default.
--- @return string s String with trimmed characters on both sides.
function string:trim(chars)
	chars = chars or "%s"
	return self:trimstart(chars):trimend(chars)
end

--- Trims string's characters from its left side. Trims whitespaces by default. The `chars` argument is a pattern string
--- containing which characters to trim
--- @param chars? string Pattern that represents which characters to trim from the start. Whitespaces by default.
--- @return string s String with trimmed characters at the start.
function string:trimstart(chars)
	return self:gsub("^["..(chars or "%s").."]+", "")
end

--- Trims string's characters from its right side. Trims whitespaces by default. The `chars` argument is a pattern
--- string containing which characters to trim.
--- @param chars? string Pattern that represents Which characters to trim from the end. Whitespaces by default.
--- @return string s String with trimmed characters at the end.
function string:trimend(chars)
	return self:gsub("["..(chars or "%s").."]+$", "")
end

--- Pads the string at the start with specified string until specified length.
--- @param len number To which length pad the string.
--- @param str? string String to pad the string with. " " by default
--- @return string s Padded string or the string itself if this parameter is less than string's length.
function string:padstart(len, str)
	str = str or " "
	local selflen = self:len()
	return (str:rep(math.ceil((len - selflen) / str:len()))..self):sub(-(selflen < len and len or selflen))
end

--- Pads the string at the end with specified string until specified length.
--- @param len number To which length pad the string.
--- @param str? string String to pad the string with. " " by default
--- @return string s Padded string or the string itself if this parameter is less than string's length.
function string:padend(len, str)
	str = str or " "
	local selflen = self:len()
	return (self..str:rep(math.ceil((len - selflen) / str:len()))):sub(1, selflen < len and len or selflen)
end

--- If the string starts with specified prefix then returns string itself, otherwise pads the string until it starts
--- with the prefix.
--- @param prefix string String to ensure this string starts with.
--- @return string s String that starts with specified prefix.
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

--- If the string ends with specified suffix then returns string itself, otherwise pads the string until it ends with
--- the suffix.
--- @param suffix string String to ensure this string ends with.
--- @return string s String that ends with specified prefix.
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

--- Adds backslashes before `"`, `'` and `\` characters.
--- @param eschar? string Escape character. `\` by default.
--- @param eschartbl? string[] Characters to escape. `{"\"", "'", "\\"}` by default.
--- @return string s String with escaped characters.
function string:esc(eschar, eschartbl)
	local s = ""
	eschar = eschar or "\\"
	eschartbl = eschartbl or eschars
	for char in self:iter() do
		s = includes(eschartbl, char) and s..eschar..char or s..char
	end
	return s
end

--- Strips backslashes from the string.
--- @param eschar? string Escape character. `\` by default.
--- @return string s Unescaped string with stripped escape character.
function string:unesc(eschar)
	local s = ""
	local i = 0
	eschar = eschar or "\\"
	while i <= #self do
		local char = self:sub(i, i)
		if char == eschar then
			i = i + 1
			s = s..self:sub(i, i)
		else
			s = s..char
		end
		i = i + 1
	end
	return s
end

--- Escapes pattern special characters so the string can be used in pattern matching functions as is.
--- @return string s String with escaped pattern special characters.
function string:escpattern()
	return self:esc("%", escregexchars)
end

--- Unescapes pattern special characters.
--- @return string s Unescaped string with stripped pattern `%` escape character.
function string:unescpattern()
	return self:unesc("%")
end

--- Escapes pattern special characters so the string can be used in pattern matching functions as is.
--- @return string s String with escaped pattern special characters.
--- @deprecated
function string:escregex()
	return self:esc("%", escregexchars)
end

--- Unescapes pattern special characters.
--- @return string s Unescaped string with stripped pattern `%` escape character.
--- @deprecated
function string:unescregex()
	return self:unesc("%")
end

--- Returns an iterator which can be used in `for ... in` loops.
--- @return fun(): string f Iterator.
function string:iter()
	return self:gmatch(".")
end

--- Truncates string to a specified length with optional suffix.
--- @param len number Length to which truncate the string.
--- @param suffix? string Optional string that will be added at the end.
--- @return string s Truncated string.
function string:truncate(len, suffix)
	if suffix then
		local newlen = len - suffix:len()
		return 0 < newlen and newlen < self:len() and self:sub(1, newlen)..suffix or self:sub(1, len)
	else
		return self:sub(1, len)
	end
end

--- Returns true if the string starts with specified string.
--- @param prefix string String to test that this string starts with.
--- @return boolean b `true` if the string starts with the specified prefix.
function string:startswith(prefix)
	return self:sub(0, prefix:len()) == prefix
end

--- Returns true if the string ends with specified string.
--- @param suffix string String to test that this string ends with.
--- @return boolean b `true` if the string ends with the specified suffix.
function string:endswith(suffix)
	return self:sub(self:len() - suffix:len() + 1) == suffix
end

--- Checks if the string is empty.
--- @return boolean b `true` if the string's length is 0.
function string:isempty()
	return self:len() == 0
end

--- Checks if the string consists of whitespace characters.
--- @return boolean b `true` if the string consists of whitespaces or it's empty.
function string:isblank()
	return self:match("^%s*$") ~= nil
end

--- Converts "1", "true", "on", "yes", "y" and their contraries into real boolean. Case-insensetive.
--- @return boolean | nil b Boolean corresponding to the string or nil if casting cannot be done.
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

--- Returns table containing all the chars in the string.
--- @return string[] t Table that consists of the string's characters.
function string:totable()
	local result = {}
	for ch in self:iter() do
		table.insert(result, ch)
	end
	return result
end
