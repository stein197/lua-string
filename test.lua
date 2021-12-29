require ""
local luaunit = require "luaunit"

local a = "a"
local abc = "abc"
local abcdef = "abcdef"
local empty = ""
local space = " "
local blank = " 	"
local whitespaced = " a 	"
local ae = luaunit.assertEquals
local an = luaunit.assertNil
local at = luaunit.assertTrue
local af = luaunit.assertFalse

TestString = {

	["test: __mul(): Multiplying by 0 returns empty string"] = function ()
		luaunit.assertEquals(abc * 0, "")
		luaunit.assertEquals(0 * abc, "")
	end;

	["test: __mul(): Multiplying by 1 returns the original string"] = function ()
		luaunit.assertEquals(abc * 1, "abc")
		luaunit.assertEquals(1 * abc, "abc")
	end;

	["test: __mul(): Multiplying returns correct string"] = function ()
		luaunit.assertEquals(abc * 3, "abcabcabc")
		luaunit.assertEquals(3 * abc, "abcabcabc")
	end;

	["test: __mul(): Multiplying an empty string n times returns empty one"] = function ()
		luaunit.assertEquals(empty * 100, "")
		luaunit.assertEquals(100 * empty, "")
	end;

	["test: __index(): Accessing with 0 returns nil"] = function ()
		luaunit.assertNil(abcdef[0])
	end;

	["test: __index(): Accessing with 1 returns the first character"] = function ()
		luaunit.assertEquals(abcdef[1], "a")
	end;

	["test: __index(): Accessing with an ordinary positive index"] = function ()
		luaunit.assertEquals(abcdef[3], "c")
	end;

	["test: __index(): Accessing with max positive index returns the last character"] = function ()
		luaunit.assertEquals(abcdef[6], "f")
	end;

	["test: __index(): Accessing with positive index larger than string's length returns nil"] = function ()
		luaunit.assertNil(abcdef[7])
	end;

	["test: __index(): Accessing with -1 returns the last character"] = function ()
		luaunit.assertEquals(abcdef[-1], "f")
	end;

	["test: __index(): Accessing with an ordinary negative index"] = function ()
		luaunit.assertEquals(abcdef[-3], "d")
	end;

	["test: __index(): Accessing with min negative index returns the first character"] = function ()
		luaunit.assertEquals(abcdef[-6], "a")
	end;

	["test: __index(): Accessing with negative index large than string's length returns nil"] = function ()
		luaunit.assertNil(abcdef[-7])
	end;

	["test: __index(): Accessing with any index in empty string returns nil"] = function ()
		luaunit.assertNil(empty[0])
		luaunit.assertNil(empty[1])
		luaunit.assertNil(empty[-1])
	end;

	["test: split(): Splitting empty string with empty one returns empty table"] = function()
		ae(empty:split(empty), {})
	end;
	
	["test: split(): Splitting by empty string returns table of chars"] = function ()
		ae(abc:split(empty), {"a", "b", "c"})
	end;
	
	["test: split(): Default"] = function ()
		ae(("a b c"):split(space), {"a", "b", "c"})
	end;
	
	["test: split(): Splitting by multicharacter string"] = function ()
		ae(("a, b, c"):split(", "), {"a", "b", "c"})
	end;
	
	["test: split(): Splitting repeating separators results in empty strings"] = function ()
		ae(("a-b--c"):split("-"), {"a", "b", "", "c"})
	end;
	
	["test: split(): Splitting separator returns empty strings"] = function ()
		ae(("-"):split("-"), {"", ""})
		ae(("--"):split("-"), {"", "", ""})
	end;
	
	["test: split(): Regex: Splitting empty string with empty one returns empty table"] = function()
		ae(empty:split(empty, true), {})
	end;
	
	["test: split(): Regex: Splitting by empty string returns table of chars"] = function ()
		ae(abc:split(empty, true), {"a", "b", "c"})
	end;
	
	["test: split(): Regex: Default"] = function ()
		ae(("a b c"):split("%s", true), {"a", "b", "c"})
	end;
	
	["test: split(): Regex: Splitting by multicharacter string"] = function ()
		ae(("a, b,c"):split("%s*,%s*", true), {"a", "b", "c"})
	end;
	
	["test: split(): Regex: Splitting repeating separators results in empty strings"] = function ()
		ae(("a-b--c"):split("%-+", true), {"a", "b", "c"})
	end;

	["test: trim(): Trimming empty string returns empty one"] = function ()
		ae(empty:trim(), "")
	end;
	
	["test: trim(): Trimming blank string returns empty one"] = function ()
		ae(blank:trim(), "")
	end;
	
	["test: trim(): Default"] = function ()
		ae(whitespaced:trim(), "a")
	end;
	
	["test: trim(): Trimming specified char at single side"] = function ()
		ae(abc:trim("c"), "ab")
	end;
	
	["test: trim(): Trimming specified char"] = function ()
		ae(("abcba"):trim("a"), "bcb")
	end;
	
	["test: trim(): Trimming group of chars"] = function ()
		ae(("/path/?"):trim("/%?"), "path")
	end;

	["test: trimstart(): Trimming empty string returns empty one"] = function ()
		ae(empty:trimstart(), "")
	end;
	
	["test: trimstart(): Trimming blank string returns empty one"] = function ()
		ae(blank:trimstart(), "")
	end;
	
	["test: trimstart(): Default"] = function ()
		ae(whitespaced:trimstart(), "a 	")
	end;
	
	["test: trimstart(): Trimming specified char at single side"] = function ()
		ae(abc:trimstart("a"), "bc")
	end;
	
	["test: trimstart(): Trimming group of chars"] = function ()
		ae(abcdef:trimstart("ba%s"), "cdef")
	end;

	["test: trimend(): Trimming empty string returns empty one"] = function ()
		ae(empty:trimend(), "")
	end;
	
	["test: trimend(): Trimming blank string returns empty one"] = function ()
		ae(blank:trimend(), "")
	end;
	
	["test: trimend(): Default"] = function ()
		ae(whitespaced:trimend(), " a")
	end;
	
	["test: trimend(): Trimming specified char at single side"] = function ()
		ae(abc:trimend("c"), "ab")
	end;
	
	["test: trimend(): Trimming group of chars"] = function ()
		ae(abcdef:trimend("fe%s"), "abcd")
	end;

	["test: padstart(): Padding an empty string returns pad string"] = function ()
		ae(empty:padstart(3, "0"), "000")
	end;

	["test: padstart(): Default"] = function ()
		ae(a:padstart(3, "0"), "00a")
	end;

	["test: padstart(): Padding to length less or equal than string's one returns string"] = function ()
		ae(abc:padstart(1, "0"), "abc")
		ae(abc:padstart(3, "0"), "abc")
	end;

	["test: padstart(): Padding with multicharacter string trims trailing characters"] = function ()
		ae(abcdef:padstart(6, "12"), "abcdef")
		ae(abcdef:padstart(7, "12"), "2abcdef")
		ae(abcdef:padstart(8, "12"), "12abcdef")
		ae(abcdef:padstart(9, "12"), "212abcdef")
		ae(abcdef:padstart(10, "12"), "1212abcdef")
		ae(abcdef:padstart(13, "123"), "3123123abcdef")
		ae(abcdef:padstart(14, "123"), "23123123abcdef")
	end;

	["test: padend(): Padding an empty string returns pad string"] = function ()
		ae(empty:padend(3, "0"), "000")
	end;
	
	["test: padend(): Default"] = function ()
		ae(a:padend(3, "0"), "a00")
	end;
	
	["test: padend(): Padding to length less or equal than string's one returns string"] = function ()
		ae(abc:padend(1, "0"), "abc")
		ae(abc:padend(3, "0"), "abc")
	end;
	
	["test: padend(): Padding with multicharacter string trims trailing characters"] = function ()
		ae(abcdef:padend(6, "12"), "abcdef")
		ae(abcdef:padend(7, "12"), "abcdef1")
		ae(abcdef:padend(8, "12"), "abcdef12")
		ae(abcdef:padend(9, "12"), "abcdef121")
		ae(abcdef:padend(10, "12"), "abcdef1212")
		ae(abcdef:padend(13, "123"), "abcdef1231231")
		ae(abcdef:padend(14, "123"), "abcdef12312312")
	end;

	["test: ensurestart(): Ensuring empty string returns prefix"] = function ()
		ae(empty:ensurestart("/"), "/")
		ae(empty:ensurestart("path/"), "path/")
	end;

	["test: ensurestart(): Ensuring with empty string returns the string"] = function ()
		ae(a:ensurestart(""), "a")
		ae(abc:ensurestart(""), "abc")
	end;

	["test: ensurestart(): Ensuring with single char"] = function ()
		ae(a:ensurestart("/"), "/a")
		ae(("/a"):ensurestart("/"), "/a")
		ae(abc:ensurestart("/"), "/abc")
		ae(("/abc"):ensurestart("/"), "/abc")
	end;

	["test: ensurestart(): Ensuring with string"] = function ()
		ae(("def"):ensurestart("abc"), "abcdef")
		ae(("cdef"):ensurestart("abc"), "abcdef")
		ae(("abcdef"):ensurestart("abc"), "abcdef")
	end;

	["test: ensurestart(): Ensuring with prefix larger than the string returns prefix"] = function ()
		ae(("c"):ensurestart("bc"), "bc")
		ae(("def"):ensurestart("abcdef"), "abcdef")
	end;

	["test: ensurestart(): Ensuring with prefix larger than the string and partially matches the string"] = function ()
		ae(("defghi"):ensurestart("abcdefg"), "abcdefghi")
	end;

	["test: ensurestart(): Ensuring with prefix larger than the string and does not match the string"] = function ()
		ae(abc:ensurestart("defghi"), "defghiabc")
	end;

	["test: ensureend(): Ensuring empty string returns suffix"] = function ()
		ae(empty:ensureend("/"), "/")
		ae(empty:ensureend("path/"), "path/")
	end;
	
	["test: ensureend(): Ensuring with empty string returns the string"] = function ()
		ae(a:ensureend(""), "a")
		ae(abc:ensureend(""), "abc")
	end;
	
	["test: ensureend(): Ensuring with single char"] = function ()
		ae(a:ensureend("/"), "a/")
		ae(("a/"):ensureend("/"), "a/")
		ae(abc:ensureend("/"), "abc/")
		ae(("abc/"):ensureend("/"), "abc/")
	end;
	
	["test: ensureend(): Ensuring with string"] = function ()
		ae(abc:ensureend("def"), "abcdef")
		ae(abcdef:ensureend("def"), "abcdef")
	end;
	
	["test: ensureend(): Ensuring with suffix larger than the string returns suffix"] = function ()
		ae(a:ensureend("abc"), "abc")
		ae(abc:ensureend("abcdef"), "abcdef")
	end;
	
	["test: ensureend(): Ensuring with suffix larger than the string and partially matches the string"] = function ()
		ae(("abcdef"):ensureend("cdefghi"), "abcdefghi")
	end;
	
	["test: ensureend(): Ensuring with suffix larger than the string and does not match the string"] = function ()
		ae(abc:ensureend("defghi"), "abcdefghi")
	end;

	["test: esc(): Escaping empty string returns empty one"] = function ()
		ae(empty:esc(), "")
	end;

	["test: esc(): Escaping regular string returns the string itself"] = function ()
		ae(abc:esc(), "abc")
	end;

	["test: esc(): Escaping quotes"] = function ()
		ae(("abc'"):esc(), "abc\\'")
		ae(("abc\""):esc(), "abc\\\"")
	end;

	["test: esc(): Double escaping"] = function ()
		ae(("abc'"):esc():esc(), "abc\\\\\\'")
	end;

	["test: esc(): Escaping single backslash"] = function ()
		ae(("\\"):esc(), "\\\\")
	end;

	["test: unesc(): Unescaping empty string returns empty one"] = function ()
		ae(empty:unesc(), "")
	end;

	["test: unesc(): Unescaping regular string returns the string itself"] = function ()
		ae(abc:unesc(), "abc")
	end;

	["test: unesc(): Unescaping quotes returns the string itself"] = function ()
		ae(("'"):unesc(), "'")
		ae(("\""):unesc(), "\"")
		ae(("abc'"):unesc(), "abc'")
	end;

	["test: unesc(): Default"] = function ()
		ae(("abc\\'"):unesc(), "abc'")
		ae(("abc\\\\\\'"):unesc():unesc(), "abc'")
		ae(("\\"):unesc(), "")
		ae(("\\\\"):unesc(), "\\")
		ae(("abc\\"):unesc(), "abc")
	end;

	["test: unesc(): Unescaping escaped string returns itself"] = function ()
		ae(("a\\bc'"):esc():unesc(), "a\\bc'")
	end;

	["test: escpattern()"] = function ()
		luaunit.assertEquals((""):escpattern(), "")
		luaunit.assertEquals(("."):escpattern(), "%.")
		luaunit.assertEquals(("%a"):escpattern(), "%%a")
		luaunit.assertEquals(("%c"):escpattern(), "%%c")
		luaunit.assertEquals(("%d"):escpattern(), "%%d")
		luaunit.assertEquals(("%g"):escpattern(), "%%g")
		luaunit.assertEquals(("%l"):escpattern(), "%%l")
		luaunit.assertEquals(("%p"):escpattern(), "%%p")
		luaunit.assertEquals(("%s"):escpattern(), "%%s")
		luaunit.assertEquals(("%u"):escpattern(), "%%u")
		luaunit.assertEquals(("%w"):escpattern(), "%%w")
		luaunit.assertEquals(("%x"):escpattern(), "%%x")
		luaunit.assertEquals(("("):escpattern(), "%(")
		luaunit.assertEquals((")"):escpattern(), "%)")
		luaunit.assertEquals(("."):escpattern(), "%.")
		luaunit.assertEquals(("%"):escpattern(), "%%")
		luaunit.assertEquals(("%"):escpattern():escpattern(), "%%%%")
		luaunit.assertEquals(("+"):escpattern(), "%+")
		luaunit.assertEquals(("-"):escpattern(), "%-")
		luaunit.assertEquals(("*"):escpattern(), "%*")
		luaunit.assertEquals(("?"):escpattern(), "%?")
		luaunit.assertEquals(("["):escpattern(), "%[")
		luaunit.assertEquals(("]"):escpattern(), "%]")
		luaunit.assertEquals(("^"):escpattern(), "%^")
		luaunit.assertEquals(("$"):escpattern(), "%$")
		luaunit.assertEquals((".%a%c%d%g%l%p%s%u%w%x().%+-*?[]^$"):escpattern(), "%.%%a%%c%%d%%g%%l%%p%%s%%u%%w%%x%(%)%.%%%+%-%*%?%[%]%^%$")
	end;
	
	["test: unescpattern()"] = function ()
		luaunit.assertEquals((""):unescpattern(), "")
		luaunit.assertEquals(("%."):unescpattern(), ".")
		luaunit.assertEquals(("%%a"):unescpattern(), "%a")
		luaunit.assertEquals(("%%c"):unescpattern(), "%c")
		luaunit.assertEquals(("%%d"):unescpattern(), "%d")
		luaunit.assertEquals(("%%g"):unescpattern(), "%g")
		luaunit.assertEquals(("%%l"):unescpattern(), "%l")
		luaunit.assertEquals(("%%p"):unescpattern(), "%p")
		luaunit.assertEquals(("%%s"):unescpattern(), "%s")
		luaunit.assertEquals(("%%u"):unescpattern(), "%u")
		luaunit.assertEquals(("%%w"):unescpattern(), "%w")
		luaunit.assertEquals(("%%x"):unescpattern(), "%x")
		luaunit.assertEquals(("%("):unescpattern(), "(")
		luaunit.assertEquals(("%)"):unescpattern(), ")")
		luaunit.assertEquals(("%."):unescpattern(), ".")
		luaunit.assertEquals(("%%"):unescpattern(), "%")
		luaunit.assertEquals(("%%%%"):unescpattern():unescpattern(), "%")
		luaunit.assertEquals(("%+"):unescpattern(), "+")
		luaunit.assertEquals(("%-"):unescpattern(), "-")
		luaunit.assertEquals(("%*"):unescpattern(), "*")
		luaunit.assertEquals(("%?"):unescpattern(), "?")
		luaunit.assertEquals(("%["):unescpattern(), "[")
		luaunit.assertEquals(("%]"):unescpattern(), "]")
		luaunit.assertEquals(("%^"):unescpattern(), "^")
		luaunit.assertEquals(("%$"):unescpattern(), "$")
		luaunit.assertEquals(("%.%%a%%c%%d%%g%%l%%p%%s%%u%%w%%x%(%)%.%%%+%-%*%?%[%]%^%$"):unescpattern(), ".%a%c%d%g%l%p%s%u%w%x().%+-*?[]^$")
	end;

	["test: escregex()"] = function ()
		luaunit.assertEquals((""):escregex(), "")
		luaunit.assertEquals(("."):escregex(), "%.")
		luaunit.assertEquals(("%a"):escregex(), "%%a")
		luaunit.assertEquals(("%c"):escregex(), "%%c")
		luaunit.assertEquals(("%d"):escregex(), "%%d")
		luaunit.assertEquals(("%g"):escregex(), "%%g")
		luaunit.assertEquals(("%l"):escregex(), "%%l")
		luaunit.assertEquals(("%p"):escregex(), "%%p")
		luaunit.assertEquals(("%s"):escregex(), "%%s")
		luaunit.assertEquals(("%u"):escregex(), "%%u")
		luaunit.assertEquals(("%w"):escregex(), "%%w")
		luaunit.assertEquals(("%x"):escregex(), "%%x")
		luaunit.assertEquals(("("):escregex(), "%(")
		luaunit.assertEquals((")"):escregex(), "%)")
		luaunit.assertEquals(("."):escregex(), "%.")
		luaunit.assertEquals(("%"):escregex(), "%%")
		luaunit.assertEquals(("%"):escregex():escregex(), "%%%%")
		luaunit.assertEquals(("+"):escregex(), "%+")
		luaunit.assertEquals(("-"):escregex(), "%-")
		luaunit.assertEquals(("*"):escregex(), "%*")
		luaunit.assertEquals(("?"):escregex(), "%?")
		luaunit.assertEquals(("["):escregex(), "%[")
		luaunit.assertEquals(("]"):escregex(), "%]")
		luaunit.assertEquals(("^"):escregex(), "%^")
		luaunit.assertEquals(("$"):escregex(), "%$")
		luaunit.assertEquals((".%a%c%d%g%l%p%s%u%w%x().%+-*?[]^$"):escregex(), "%.%%a%%c%%d%%g%%l%%p%%s%%u%%w%%x%(%)%.%%%+%-%*%?%[%]%^%$")
	end;

	["test: unescregex()"] = function ()
		luaunit.assertEquals((""):unescregex(), "")
		luaunit.assertEquals(("%."):unescregex(), ".")
		luaunit.assertEquals(("%%a"):unescregex(), "%a")
		luaunit.assertEquals(("%%c"):unescregex(), "%c")
		luaunit.assertEquals(("%%d"):unescregex(), "%d")
		luaunit.assertEquals(("%%g"):unescregex(), "%g")
		luaunit.assertEquals(("%%l"):unescregex(), "%l")
		luaunit.assertEquals(("%%p"):unescregex(), "%p")
		luaunit.assertEquals(("%%s"):unescregex(), "%s")
		luaunit.assertEquals(("%%u"):unescregex(), "%u")
		luaunit.assertEquals(("%%w"):unescregex(), "%w")
		luaunit.assertEquals(("%%x"):unescregex(), "%x")
		luaunit.assertEquals(("%("):unescregex(), "(")
		luaunit.assertEquals(("%)"):unescregex(), ")")
		luaunit.assertEquals(("%."):unescregex(), ".")
		luaunit.assertEquals(("%%"):unescregex(), "%")
		luaunit.assertEquals(("%%%%"):unescregex():unescregex(), "%")
		luaunit.assertEquals(("%+"):unescregex(), "+")
		luaunit.assertEquals(("%-"):unescregex(), "-")
		luaunit.assertEquals(("%*"):unescregex(), "*")
		luaunit.assertEquals(("%?"):unescregex(), "?")
		luaunit.assertEquals(("%["):unescregex(), "[")
		luaunit.assertEquals(("%]"):unescregex(), "]")
		luaunit.assertEquals(("%^"):unescregex(), "^")
		luaunit.assertEquals(("%$"):unescregex(), "$")
		luaunit.assertEquals(("%.%%a%%c%%d%%g%%l%%p%%s%%u%%w%%x%(%)%.%%%+%-%*%?%[%]%^%$"):unescregex(), ".%a%c%d%g%l%p%s%u%w%x().%+-*?[]^$")
	end;

	["test: iter(): Calling at empty string returns empty loop"] = function ()
		local r = {}
		for char in empty:iter() do
			table.insert(r, char)
		end
		luaunit.assertEquals(r, {})
	end;

	["test: iter(): Default"] = function ()
		local r = {}
		for char in abc:iter() do
			table.insert(r, char)
		end
		luaunit.assertEquals(r, {"a", "b", "c"})
	end;

	["test: truncate(): Truncating empty string always returns empty one"] = function ()
		ae(empty:truncate(1), "")
		ae(empty:truncate(0), "")
		ae(empty:truncate(-1), "")
		ae(empty:truncate(1, ""), "")
		ae(empty:truncate(0, ""), "")
		ae(empty:truncate(-1, ""), "")
		ae(empty:truncate(1, "..."), "")
		ae(empty:truncate(0, "..."), "")
		ae(empty:truncate(-1, "..."), "")
	end;

	["test: truncate(): Truncating single character always returns either character itself or an empty one"] = function ()
		ae(a:truncate(1), "a")
		ae(a:truncate(0), "")
		ae(a:truncate(-1), "a")
		ae(a:truncate(1, ""), "a")
		ae(a:truncate(0, ""), "")
		ae(a:truncate(-1, ""), "a")
		ae(a:truncate(1, "b"), "a")
		ae(a:truncate(0, "b"), "")
		ae(a:truncate(-1, "b"), "a")
		ae(a:truncate(1, "..."), "a")
		ae(a:truncate(0, "..."), "")
		ae(a:truncate(-1, "..."), "a")
	end;

	["test: truncate(): Default"] = function ()
		ae(abcdef:truncate(3), "abc")
	end;

	["test: truncate(): Truncating the string to it's length returns the string itself"] = function ()
		ae(abcdef:truncate(6), "abcdef")
	end;

	["test: truncate(): Truncating the string to it's length with prefix"] = function ()
		ae(abcdef:truncate(6, "..."), "abc...")
	end;

	["test: truncate(): Truncating the string to large length returns the string itself"] = function ()
		ae(abcdef:truncate(100), "abcdef")
	end;

	["test: truncate(): Truncating the string to large length with prefix returns the string itself"] = function ()
		ae(abcdef:truncate(100, "..."), "abcdef")
	end;

	["test: truncate(): Truncating the string to a total length with prefix returns the string itself"] = function ()
		luaunit.assertEquals(("abcdef"):truncate(9, "..."), "abcdef")
	end;

	["test: startswith(): Calling with empty string always returns true"] = function ()
		at(empty:startswith(""))
		at(a:startswith(""))
		at(abc:startswith(""))
	end;
	
	["test: startswith(): Default"] = function ()
		at(a:startswith("a"))
		at(abc:startswith("ab"))
		af(abc:startswith("c"))
	end;
	["test: endswith(): Calling with empty string always returns true"] = function ()
		at(empty:endswith(""))
		at(a:endswith(""))
		at(abc:endswith(""))
	end;

	["test: endswith(): Default"] = function ()
		at(a:endswith("a"))
		at(abc:endswith("bc"))
		af(abc:endswith("a"))
	end;

	["test: isempty(): Calling at empty string returns true"] = function ()
		at(empty:isempty())
	end;

	["test: isempty(): Calling at blank string returns false"] = function ()
		af(space:isempty())
	end;

	["test: isempty(): Calling at arbitrary string returns true"] = function ()
		af(a:isempty())
		af(abc:isempty())
	end;

	["test: isblank(): Calling at empty string returns true"] = function ()
		at(empty:isblank())
	end;

	["test: isblank(): Calling at whitespaced string returns true"] = function ()
		at((" "):isblank())
		at((" 	"):isblank())
		at((" 	\n"):isblank())
	end;

	["test: isblank(): Calling at arbitrary string returns false"] = function ()
		af(a:isblank())
		af(abc:isblank())
	end;

	["test: tobool(): Default"] = function ()
		at(("1"):tobool())
		at(("true"):tobool())
		at(("on"):tobool())
		at(("yes"):tobool())
		at(("y"):tobool())
		at(("TRUE"):tobool())
		at(("ON"):tobool())
		at(("YES"):tobool())
		at(("Y"):tobool())
		af(("0"):tobool())
		af(("false"):tobool())
		af(("off"):tobool())
		af(("no"):tobool())
		af(("n"):tobool())
		af(("FALSE"):tobool())
		af(("OFF"):tobool())
		af(("NO"):tobool())
		af(("N"):tobool())
	end;
	
	["test: tobool(): Converting empty string returns nil"] = function ()
		an(empty:tobool())
	end;

	["test: tobool(): Converting arbitrary string returns nil"] = function ()
		an(abc:tobool())
	end;

	["test: totable(): Converting empty string returns empty table"] = function ()
		ae(empty:totable(), {})
	end;

	["test: totable(): Converting single char string returns table with one item"] = function ()
		ae(a:totable(), {"a"})
	end;

	["test: totable(): Default"] = function ()
		ae(abc:totable(), {"a", "b", "c"})
	end;
}

os.exit(luaunit.run())
