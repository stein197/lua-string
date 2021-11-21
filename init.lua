local boolvalues = {
	["1"] = "0";
	["true"] = "false";
	["on"] = "off";
	["yes"] = "no";
	["y"] = "n"
}

--- Splits string by supplied separator
function string.split(self, sep)
	if sep == "" then
		return self:totable()
	end
	local result = {}
	local previdx = 1
	while true do
		local startidx, endidx = self:find(sep, previdx, true)
		if not startidx then
			table.insert(result, self:sub(previdx))
			break
		end
		table.insert(result, self:sub(previdx, startidx - 1))
		previdx = endidx + 1
	end
	return result
end

-- Splits string by supplied regular expression string
function string.splitregex(self, regex)
	local result = {}
	local previdx = 1
	for match in self:gmatch(regex) do
		local startidx, endidx = self:find(match, previdx, true)
		table.insert(result, self:sub(previdx, startidx - 1))
		previdx = endidx + 1
	end
	table.insert(result, self:sub(previdx))
	return result
end

-- Trims string's characters from its endings. Trims whitespaces by default
function string.trim(self, chars)
	local chars = chars or "%s"
	return self:gsub("^"..chars, ""):gsub(chars.."$", "")
end

-- Pads string with spacified char until specified length. " " pad char by default
function string.padstart(self, len, char)
	local charsmount = self:len() - len
	if charsmount <= 0 then
		return self
	end
	local char = char or " "
	return char:rep(charsmount)..self
end

-- Pads string with spacified char until specified length. " " pad char by default
function string.padend(self, len, char)
	local charsmount = self:len() - len
	if charsmount <= 0 then
		return self
	end
	local char = char or " "
	return self..char:rep(charsmount)
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
	return suffix and self:len() + suffix:len() > len and self:sub(1, len - suffix:len())..suffix or self:sub(1, len)
end

-- Returns true if string starts with prefix
function string.startswith(self, prefix)
	return self:match("^"..prefix:escaperegex()) ~= nil
end

-- Returns true if string ends with prefix
function string.endswith(self, suffix)
	return self:match(suffix:escaperegex().."$") ~= nil
end

-- Returns true if string length is 0
function string.isempty(self)
	return self:len() == 0
end

-- Returns true if string consists of whitespace characters
function string.isblank(self)
	return self:match("^%s*$") ~= nil
end

--- Converts strings like "yes", "no", "1" and others into real boolean. Returns nil if casting cannot be done
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

--- Returns table containing all the chars in the string
function string.totable(self)
	local result = {}
	for ch in self:iter() do
		table.insert(result, ch)
	end
	return result
end
