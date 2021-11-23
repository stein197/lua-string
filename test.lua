require "."
local luaunit = require "luaunit"

local a = "a"
local abc = "abc"
local abcdef = "abcdef"
local empty = ""
local space = " "
local blank = " 	"
local whitespaced = "whitespaced"
local ae = luaunit.assertEquals

TestString = {

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

	["test: padstart()"] = function ()
		luaunit.assertEquals((""):padstart(3, "0"), "000")
		luaunit.assertEquals(("1"):padstart(3, "0"), "001")
		luaunit.assertEquals(("1"):padstart(1, "0"), "1")
	end;

	["test: padend()"] = function ()
		luaunit.assertEquals((""):padend(3, "0"), "000")
		luaunit.assertEquals(("1"):padend(3, "0"), "100")
		luaunit.assertEquals(("1"):padend(1, "0"), "1")
	end;

	["test: ensurestart()"] = function () error("Not implemented") end; -- TODO
	["test: ensureend()"] = function () error("Not implemented") end; -- TODO

	["test: esc()"] = function ()
		luaunit.assertEquals((""):esc(), "")
		luaunit.assertEquals(("abc"):esc(), "abc")
		luaunit.assertEquals(("abc'"):esc(), "abc\\'")
		luaunit.assertEquals(("abc'"):esc():esc(), "abc\\\\\\'")
		luaunit.assertEquals(("\\"):esc(), "\\\\")
	end;

	["test: unesc()"] = function ()
		luaunit.assertEquals((""):unesc(), "")
		luaunit.assertEquals(("abc"):unesc(), "abc")
		luaunit.assertEquals(("abc'"):unesc(), "abc'")
		luaunit.assertEquals(("abc\\'"):unesc(), "abc'")
		luaunit.assertEquals(("abc\\\\\\'"):unesc():unesc(), "abc'")
		luaunit.assertEquals(("\\"):unesc(), "")
		luaunit.assertEquals(("\\\\"):unesc(), "\\")
		luaunit.assertEquals(("abc\\"):unesc(), "abc")
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

	["test: iter()"] = function ()
		local iter = (""):iter()
		local r = {}
		for char in iter do
			table.insert(r, char)
		end
		luaunit.assertEquals(r, {})

		iter = ("abc"):iter()
		r = {}
		for char in iter do
			table.insert(r, char)
		end
		luaunit.assertEquals(r, {"a", "b", "c"})
	end;

	["test: truncate()"] = function ()
		luaunit.assertEquals((""):truncate(1), "")
		luaunit.assertEquals((""):truncate(1, "..."), "")
		luaunit.assertEquals((""):truncate(0), "")
		luaunit.assertEquals((""):truncate(-1), "")

		luaunit.assertEquals(("a"):truncate(1), "a")
		luaunit.assertEquals(("a"):truncate(2), "a")
		luaunit.assertEquals(("a"):truncate(1, "..."), "a")
		luaunit.assertEquals(("a"):truncate(0), "")
		luaunit.assertEquals(("a"):truncate(-1), "a")

		luaunit.assertEquals(("abcdef"):truncate(3), "abc")
		luaunit.assertEquals(("abcdef"):truncate(6, "..."), "abc...")
		luaunit.assertEquals(("abcdef"):truncate(100, "..."), "abcdef")
		luaunit.assertEquals(("abcdef"):truncate(9, "..."), "abcdef")
		luaunit.assertEquals(("abcdef"):truncate(0), "")
		luaunit.assertEquals(("abcdef"):truncate(-1), "abcdef")

	end;

	["test: startswith()"] = function ()
		luaunit.assertTrue((""):startswith(""))
		luaunit.assertTrue(("a"):startswith("a"))
		luaunit.assertTrue(("abc"):startswith("ab"))
		luaunit.assertFalse(("abc"):startswith("c"))
	end;

	["test: endswith()"] = function ()
		luaunit.assertTrue((""):endswith(""))
		luaunit.assertTrue(("a"):endswith("a"))
		luaunit.assertTrue(("abc"):endswith("bc"))
		luaunit.assertFalse(("abc"):endswith("a"))
	end;

	["test: isempty()"] = function ()
		luaunit.assertTrue((""):isempty())
		luaunit.assertFalse((" "):isempty())
		luaunit.assertFalse(("a"):isempty())
		luaunit.assertFalse(("abc"):isempty())
	end;

	["test: isblank()"] = function ()
		luaunit.assertTrue((""):isblank())
		luaunit.assertTrue((" "):isblank())
		luaunit.assertTrue((" 	"):isblank())
		luaunit.assertTrue((" 	\n"):isblank())
		luaunit.assertFalse(("a"):isblank())
		luaunit.assertFalse(("abc"):isblank())
	end;

	["test: tobool()"] = function ()
		luaunit.assertTrue(("1"):tobool())
		luaunit.assertTrue(("true"):tobool())
		luaunit.assertTrue(("on"):tobool())
		luaunit.assertTrue(("yes"):tobool())
		luaunit.assertTrue(("y"):tobool())
		luaunit.assertTrue(("TRUE"):tobool())
		luaunit.assertTrue(("ON"):tobool())
		luaunit.assertTrue(("YES"):tobool())
		luaunit.assertTrue(("Y"):tobool())
		luaunit.assertFalse(("0"):tobool())
		luaunit.assertFalse(("false"):tobool())
		luaunit.assertFalse(("off"):tobool())
		luaunit.assertFalse(("no"):tobool())
		luaunit.assertFalse(("n"):tobool())
		luaunit.assertFalse(("FALSE"):tobool())
		luaunit.assertFalse(("OFF"):tobool())
		luaunit.assertFalse(("NO"):tobool())
		luaunit.assertFalse(("N"):tobool())
		luaunit.assertNil((""):tobool())
		luaunit.assertNil(("abc"):tobool())
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
