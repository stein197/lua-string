# Lua string common methods
The package extends default Lua's string library with several useful common methods which are present in most other languages

Table of contents
- [API](#api)
	- [split](#split)
	- [splitregex](#splitregex)
	- [trim](#trim)
	- [padstart](#padstart)
	- [padend](#padend)
	- [iter](#iter)
	- [truncate](#truncate)
	- [startswith](#startswith)
	- [endswith](#endswith)
	- [isempty](#isempty)
	- [isblank](#isblank)
	- [tobool](#tobool)
	- [totable](#totable)

## API

<a id="split"></a>

### split(self, sep)
Splits string by supplied separator
```lua
("123-345-789"):split("-") -- {"123", "456", "789"}
```

<a id="splitregex"></a>

### splitregex(self, regex)
Splits string by supplied regular expression string
```lua
("123 , 456,789"):splitregex("%s*,%s*") -- {"123", "456", "789"}
```

<a id="trim"></a>

### trim(self, chars)
Trims string's characters from its endings. Trims whitespaces by default
```lua
(" abc "):trim() -- "abc"
(" /abc/"):trim("/ ") -- "abc"
```

<a id="padstart"></a>

### padstart(self, len, char)
Pads string at the start with specified char until specified length. " " pad char by default
```lua
("123"):padstart(6, "0") -- "000123"
```

<a id="padend"></a>

### padend(self, len, char)
Pads string at the end with specified char until specified length. " " pad char by default
```lua
("123"):padend(6, "-") -- "123---"
```

<a id="iter"></a>

### iter(self)
Returns an iterator which can be used in for loops
```lua
for char in ("abc"):iter() do
	print(char)
end
-- > a
-- > b
-- > c
```

<a id="truncate"></a>

### truncate(self, len, suffix)
Truncates string to a specified length with optional suffix (usually "...", nil by default)
```lua
("abcdef"):truncate(3) -- "abc"
("abcdef"):truncate(5, "...") -- "ab..."
```

<a id="startswith"></a>

### startswith(self, prefix)
Returns true if string starts with specified string
```lua
("abc"):startswith("ab") -- true
```

<a id="endswith"></a>

### endswith(self, suffix)
Returns true if string ends with specified string
```lua
("abc"):endswith("bc") -- true
```

<a id="isempty"></a>

### isempty(self)
Returns true if string length is 0
```lua
(""):isempty() -- true
```

<a id="isblank"></a>

### isblank(self)
Returns true if string consists of whitespace characters
```lua
(" "):isblank() -- true
```

<a id="tobool"></a>

### tobool(self)
Converts "1", "true", "on", "yes", "y" and their contraries into real boolean. Returns nil if casting cannot be done. Case-insensetive
```lua
("trUE"):tobool() -- true
("no"):tobool() -- false
("string"):tobool() -- nil
```

<a id="totable"></a>

### totable(self)
Returns table containing all the chars in the string
```lua
("abc"):totable() -- {"a", "b", "c"}
```

