package = "lua-string"
rockspec_format = "3.0"
version = "1.1.0-1"
source = {
	url = "git://github.com/stein197/lua-string",
	tag = "1.1.0",
	branch = "main"
}
description = {
	summary = "Lua standard string library extension",
	detailed = [[
		This package extends the default string library with useful methods such as:
		- split
		- trim
		- startswith, endswith
		and so on.
	]],
	homepage = "https://github.com/stein197/lua-string",
	issues_url = "https://github.com/stein197/lua-string/issues",
	license = "MIT",
	maintainer = "Nail' Gafarov <nil20122013@gmail.com>",
	labels = {
		"string", "extension", "split"
	}
}
dependencies = {
	"lua >= 5.3"
}
build = {
	type = "builtin",
	modules = {
		["lua-string"] = "init.lua"
	}
}
