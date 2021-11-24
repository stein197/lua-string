# Lua standard string library extension
The package extends default Lua's string library with several useful common methods which are present in most other languages. If you ever missed split, trim and other functions the this package provides such functions by extending Lua's default string library.

Table of contents
- [Installation](#installation)
- [Usage](#usage)
- [API](#api)
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
	- [escregex](#escregex)
	- [unescregex](#unescregex)
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
luarocks install <>
```
Or just download and require `init.lua` file from this repo.

## Usage
Just require it in the code like in the example below:
```lua
require ""
("Hello world!"):trimend("!"):sub(6):trim():totable() -- {"H", "e", "l", "l", "o"}
```

## API

<a id="split"></a>

### split(self, sep, regex)
Splits string by supplied separator. If the `regex` parameter is set to true then the separator is considered as a regular expression
```lua
```

<a id="trim"></a>

### trim(self, chars)
Trims string's characters from its endings. Trims whitespaces by default. The `chars` argument is a regex string containing which characters to trim
```lua
```

<a id="trimstart"></a>

### trimstart(self, chars)
Trims string's characters from its left side. Trims whitespaces by default. The `chars` argument is a regex string containing which characters to trim
```lua
```

<a id="trimend"></a>

### trimend(self, chars)
Trims string's characters from its right side. Trims whitespaces by default. The `chars` argument is a regex string containing which characters to trim
```lua
```

<a id="padstart"></a>

### padstart(self, len, str)
Pads string at the start with specified string until specified length. `" "` pad string by default
```lua
```

<a id="padend"></a>

### padend(self, len, str)
Pads string at the end with specified string until specified length. `" "` pad string by default
```lua
```

<a id="ensurestart"></a>

### ensurestart(self, prefix)
If the string starts with specified prefix then returns string itself, otherwise pads the string until it starts with the prefix
```lua
```

<a id="ensureend"></a>

### ensureend(self, suffix)
If the string ends with specified prefix then returns string itself, otherwise pads the string until it ends with the prefix
```lua
```

<a id="esc"></a>

### esc(self, eschar, eschartbl)
Adds backslashes before `"`, `'` and `\` characters. Escape character can be specified (`"\\"` by default) as well as characters to escape (`{"\"", "'", "\\"}` by default)
```lua
```

<a id="unesc"></a>

### unesc(self, eschar)
Strips backslashes from the string. Escape character can be specified (`"\\"` by default)
```lua
```

<a id="escregex"></a>

### escregex(self)
Escapes regexp special characters so the can be used in regexp functions as is
```lua
```

<a id="unescregex"></a>

### unescregex(self)
Unescapes regexp special characters
```lua
```

<a id="iter"></a>

### iter(self)
 Returns an iterator which can be used in for loops
 ```lua
 ```

<a id="truncate"></a>

### truncate(self, len, suffix)
 Truncates string to a specified length with optional suffix (usually `"..."`, nil by default)
 ```lua
 ```

<a id="startswith"></a>

### startswith(self, prefix)
Returns true if the string starts with specified string
```lua
```

<a id="endswith"></a>

### endswith(self, suffix)
Returns true if the string ends with specified string
```lua
```

<a id="isempty"></a>

### isempty(self)
Returns true if string's length is 0
```lua
```

<a id="isblank"></a>

### isblank(self)
Returns true if string consists of whitespace characters
```lua
```

<a id="tobool"></a>

### tobool(self)
Converts `"1"`, `"true"`, `"on"`, `"yes"`, `"y"` and their contraries into real boolean. Returns nil if casting cannot be done. Case-insensetive
```lua
```

<a id="totable"></a>

### totable(self)
Returns table containing all the chars in the string
```lua
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
Make sure that `luaunit` package can be required using `package.path` variable.
