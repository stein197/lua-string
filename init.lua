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

local function includes(tbl, item)
	for k, v in pairs(tbl) do
		if v == item then
			return true
		end
	end
	return false
end

-- Splits string by supplied separator
function string.split(self, sep, regex)
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

-- Trims string's characters from its endings. Trims whitespaces by default
function string.trim(self, chars)
	chars = chars or "%s"
	return self:trimstart(chars):trimend(chars)
end

-- Trims string's characters from its left side. Trims whitespaces by default
function string.trimstart(self, chars)
	return self:gsub("^["..(chars or "%s").."]+", "")
end

-- Trims string's characters from its right side. Trims whitespaces by default
function string.trimend(self, chars)
	return self:gsub("["..(chars or "%s").."]+$", "")
end

-- Pads string at the start with specified char until specified length. " " pad char by default
function string.padstart(self, len, str)
	str = str or " "
	local selflen = self:len()
	return (str:rep(math.ceil((len - selflen) / str:len()))..self):sub(-(selflen < len and len or selflen))
end

-- Pads string at the end with specified char until specified length. " " pad char by default
function string.padend(self, len, str)
	str = str or " "
	local selflen = self:len()
	return (self..str:rep(math.ceil((len - selflen) / str:len()))):sub(1, selflen < len and len or selflen)
end

-- If the string starts with prefix then returns string itself, otherwise pads the string until it starts the prefix
function string.ensurestart(self, prefix)
	local prefixlen = prefix:len()
	if prefixlen > self:len() then
		return prefix:ensureend(self)
	end
	local left = self:sub(1, prefixlen)
	local i = 1
	while not prefix:endswith(left) and i < prefixlen do
		i = i + 1
		left = left:sub(1, -2)
	end
	return prefix:sub(1, i - 1)..self
end

-- If the string ends with prefix then returns string itself, otherwise pads the string until it ends the prefix
function string.ensureend(self, suffix)
	local suffixlen = suffix:len()
	if suffixlen > self:len() then
		return suffix:ensurestart(self)
	end
	local right = self:sub(-suffixlen)
	local i = suffixlen
	while not suffix:startswith(right) and i >= 1 do
		i = i - 1
		right = right:sub(-2)
	end
	return self..suffix:sub(i + 1)
end

-- Adds backslashes before ", ' and \ characters. Escape character can be specified ("\\" by default) as well as
-- characters to escape ({"\"", "'", "\\"} by default)
function string.esc(self, eschar, eschartbl)
	local result = ""
	eschar = eschar or "\\"
	eschartbl = eschartbl or eschars
	for char in self:iter() do
		result = includes(eschartbl, char) and result..eschar..char or result..char
	end
	return result
end

-- Strips backslashes from the string. Escape character can be specified ("\\" by default)
function string.unesc(self, eschar)
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

-- Escapes regexp special characters so the can be used in regexp function as is
function string.escregex(self)
	return self:esc("%", escregexchars)
end

-- Unescapes regexp special characters
function string.unescregex(self)
	return self:unesc("%")
end

--- Returns an iterator which can be used in for loops
function string.iter(self)
	local i = 0
	return function ()
		i = i + 1
		return i <= self:len() and self:sub(i, i) or nil
	end
end

--- Truncates string to a specified length with optional suffix (usually "...", nil by default)
function string.truncate(self, len, suffix)
	if suffix then
		local newlen = len - suffix:len()
		return 0 <= newlen and newlen < self:len() and self:sub(1, newlen)..suffix or self:sub(1, len)
	else
		return self:sub(1, len)
	end
end

-- Returns true if string starts with specified string
function string.startswith(self, prefix)
	return self:sub(0, prefix:len()) == prefix
end

-- Returns true if string ends with specified string
function string.endswith(self, suffix)
	return self:sub(self:len() - suffix:len() + 1) == suffix
end

-- Returns true if string length is 0
function string.isempty(self)
	return self:len() == 0
end

-- Returns true if string consists of whitespace characters
function string.isblank(self)
	return self:match("^%s*$") ~= nil
end

-- Converts "1", "true", "on", "yes", "y" and their contraries into real boolean. Returns nil if casting cannot be done.
-- Case-insensetive
function string.tobool(self)
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
function string.totable(self)
	local result = {}
	for ch in self:iter() do
		table.insert(result, ch)
	end
	return result
end
