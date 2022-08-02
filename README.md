# Lua standard string library extension
[![](https://img.shields.io/github/license/stein197/lua-string)](LICENSE)
![](https://img.shields.io/github/v/tag/stein197/lua-string?label=Version)
[![](https://img.shields.io/luarocks/v/stein197/lua-string)](https://luarocks.org/modules/stein197/lua-string)
[![](https://img.shields.io/github/size/stein197/lua-string/init.lua)](init.lua)

The package extends default Lua's string library with several useful common methods which are present in most other languages. If you ever missed split, trim and other functions the this package provides such functions by extending Lua's default string library.

**Table of contents**
- [Installation](#installation)
- [Usage](#usage)
- [API](#api)
	- [__mul](#__mul)
	- [__index](#__index)
	- [split](#split)
	- [trim](#trim)
	- [trimstart](#trimstart)
	- [trimend](#trimend)
	- [padstart](#padstart)
	- [padend](#padend)
	- [ensurestart](#ensurestart)
	- [ensureend](#ensureend)
	- [esc](#esc)
	- [unesc](#unesc)
	- [escpattern](#escpattern)
	- [unescpattern](#unescpattern)
	- [escregex (Deprecated)](#escregex)
	- [unescregex (Deprecated)](#unescregex)
	- [iter](#iter)
	- [truncate](#truncate)
	- [startswith](#startswith)
	- [endswith](#endswith)
	- [isempty](#isempty)
	- [isblank](#isblank)
	- [tobool](#tobool)
	- [totable](#totable)
- [Testing](#testing)

## Installation
Via LuaRocks:
```
luarocks install lua-string
```
Or just download and require `init.lua` file from this repo.

## Usage
Just require it in the code like in the example below:
```lua
require "lua-string" -- It will extend the default string library
("Hello world!"):trimend("!"):sub(6):trim():totable() -- {"H", "e", "l", "l", "o"}
```

## API

<a id="__mul"></a>

### __mul(n)
Overloads `*` operator. Works the same as `string.rep()` function.
```lua
("abc") * 2 -- "abcabc"
```

<a id="__index"></a>

### __index(i)
Overloads `[]` operator. It's possible to access individual chars with this operator. Index could be negative. In that case the counting will start from the end.
```lua
("abc")[1] -- "a"
("abc")[-1] -- "c"
```

<a id="split"></a>

### split(sep, pattern)
Splits string by supplied separator. If the `pattern` parameter is set to true then the separator is considered as a pattern
```lua
("a b c"):split(" ") -- {"a", "b", "c"}
("a,b, c"):split("%s*,%s*", true) -- {"a", "b", "c"}
```

<a id="trim"></a>

### trim(chars)
Trims string's characters from its endings. Trims whitespaces by default. The `chars` argument is a pattern string containing which characters to trim
```lua
(" abc "):trim() -- "abc"
(" abc !"):trim("! ") -- "abc"
```

<a id="trimstart"></a>

### trimstart(chars)
Trims string's characters from its left side. Trims whitespaces by default. The `chars` argument is a pattern string containing which characters to trim
```lua
(" abc "):trimstart() -- "abc "
(" abc !"):trimstart("! ") -- "abc !"
```

<a id="trimend"></a>

### trimend(chars)
Trims string's characters from its right side. Trims whitespaces by default. The `chars` argument is a pattern string containing which characters to trim
```lua
(" abc "):trimend() -- " abc"
(" abc !"):trimend("! ") -- " abc"
```

<a id="padstart"></a>

### padstart(len, str)
Pads string at the start with specified string until specified length. `" "` pad string by default
```lua
("1"):padstart(3) -- "  1"
("1"):padstart(3, "0") -- "001"
```

<a id="padend"></a>

### padend(len, str)
Pads string at the end with specified string until specified length. `" "` pad string by default
```lua
("1"):padend(3) -- "1  "
("1"):padend(3, "0") -- "100"
```

<a id="ensurestart"></a>

### ensurestart(prefix)
If the string starts with specified prefix then returns string itself, otherwise pads the string until it starts with the prefix
```lua
("domain.com"):ensurestart("https://") -- "https://domain.com"
("https://domain.com"):ensurestart("https://") -- "https://domain.com"
```

<a id="ensureend"></a>

### ensureend(suffix)
If the string ends with specified prefix then returns string itself, otherwise pads the string until it ends with the prefix
```lua
("path"):ensureend("/") -- "path/"
("path/"):ensureend("/") -- "path/"
```

<a id="esc"></a>

### esc(eschar, eschartbl)
Adds backslashes before `"`, `'` and `\` characters. Escape character can be specified (`"\\"` by default) as well as characters to escape (`{"\"", "'", "\\"}` by default)
```lua
("Quote'"):esc() -- "Quote\\'"
("string%"):esc("#", {"%"}) -- "string#%"
```

<a id="unesc"></a>

### unesc(eschar)
Strips backslashes from the string. Escape character can be specified (`"\\"` by default)
```lua
("Quote\\'"):unesc() -- "Quote'"
("string#%"):unesc("#") -- "string%"
```

<a id="escpattern"></a>

### escpattern(self)
Escapes pattern special characters so the can be used in pattern matching functions as is
```lua
("^[abc]"):escpattern() -- "%^%[abc%]"
```

<a id="unescpattern"></a>

### unescpattern(self)
Unescapes pattern special characters
```lua
("%^%[abc%]"):unescpattern() -- "^[abc]"
```

<a id="escregex"></a>

### escregex(self)
Escapes pattern special characters so the can be used in pattern functions as is. Deprecated, use `escpattern` instead
```lua
("^[abc]"):escregex() -- "%^%[abc%]"
```

<a id="unescregex"></a>

### unescregex(self)
Unescapes pattern special characters. Deprecated, use `unescpattern` instead
```lua
("%^%[abc%]"):unescregex() -- "^[abc]"
```

<a id="iter"></a>

### iter(self)
Returns an iterator which can be used in for loops
```lua
for char in ("abc"):iter() do
	print(char)
end
> a
> b
> c
```

<a id="truncate"></a>

### truncate(len, suffix)
Truncates string to a specified length with optional suffix (usually `"..."`, nil by default)
```lua
("string"):truncate(3) -- "str"
("string"):truncate(5, "...") -- "st..."
```

<a id="startswith"></a>

### startswith(prefix)
Returns true if the string starts with specified string
```lua
("string"):startswith("str") -- true
```

<a id="endswith"></a>

### endswith(suffix)
Returns true if the string ends with specified string
```lua
("string"):endswith("ing") -- true
```

<a id="isempty"></a>

### isempty(self)
Returns true if string's length is 0
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
Converts `"1"`, `"true"`, `"on"`, `"yes"`, `"y"` and their contraries into real boolean. Returns nil if casting cannot be done. Case-insensetive
```lua
("true"):tobool() -- true
("off"):tobool() -- false
("string"):tobool() -- nil
```

<a id="totable"></a>

### totable(self)
Returns table containing all the chars in the string
```lua
("abc"):totable() -- {"a", "b", "c"}
```


## Testing
Install luaunit package:
```
luarocks install luaunit
```
Then run from the console:
```
lua test.lua
```
