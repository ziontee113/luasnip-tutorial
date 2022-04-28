local ls = require("luasnip") --{{{
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

-- --

local snippets = {}
local autosnippets = {}

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local map = vim.keymap.set
local opts = { noremap = true, silent = true, buffer = true }
local group = augroup("PlantUML Snippets", { clear = true })

local function cs(trigger, nodes, keymap) --> cs stands for create snippet
	local snippet = s(trigger, nodes)
	table.insert(snippets, snippet)

	if keymap ~= nil then
		local pattern = "*.md"
		if type(keymap) == "table" then
			pattern = keymap[1]
			keymap = keymap[2]
		end
		autocmd("BufEnter", {
			pattern = pattern,
			group = group,
			callback = function()
				map({ "i" }, keymap, function()
					ls.snip_expand(snippet)
				end, opts)
			end,
		})
	end
end

local function lp(package_name) -- Load Package Function
	package.loaded[package_name] = nil
	return require(package_name)
end --}}}

-- Utility Functions --

local function toCamelCase(str) --{{{
	if #str == 0 or str == nil or type(str) == "table" then
		return ""
	end

	local words = {}
	local index = 1
	for word in str:gmatch("%w+") do
		if index == 1 then
			table.insert(words, word:lower())
		else
			table.insert(words, word:sub(1, 1):upper() .. word:sub(2):lower())
		end
		index = index + 1
	end

	return table.concat(words, "")
end --}}}

local function same_toLowerCase_function(index) --{{{
	return f(function(arg)
		return toCamelCase(arg[1][1])
	end, { index })
end

local function same_toLowerCase_dynamic(nodes, index)
	return d(index, function(arg)
		return sn(index, i(1, toCamelCase(arg[1][1])))
	end, { nodes })
end --}}}
local function previousLine()
	local currentLine = vim.api.nvim_win_get_cursor(0)
	local prevLine = vim.api.nvim_buf_get_lines(0, currentLine - 1, currentLine, false)
	P(prevLine)
end

-- Start Refactoring --

local actor_snippet_fmt = fmt( -- PlantUML Actor Snippet{{{
	[[ 
{} "{}" as {}
]],
	{
		c(1, { t("actor"), t("usecase") }),
		i(2, ""),
		same_toLowerCase_dynamic(2, 3),
	}
)
cs("actor_plantUML", actor_snippet_fmt, "jj") --}}}
cs( -- PlantUML Start @startuml Snippet{{{
	"startuml",
	fmt(
		[[ 
@startuml
{}
{}
@enduml
]],
		{
			c(1, { t("left to right direction"), t("") }),
			i(2, ""),
		}
	),
	"jks"
) --}}}
cs( -- PlantUML Direction Snippet{{{
	{ trig = "dir", regTrig = true, hidden = true },
	fmt(
		[[ 
{}
]],
		{ c(1, { t("left to right direction"), t("") }) }
	)
) --}}}
cs( -- Double Arrow Relationship Snippet{{{
	"doubleArrow",
	fmt(
		[[
{} {} {}
]],
		{
			i(1, "from"),
			c(2, { t("-->"), t("<--") }),
			i(3, "to"),
		}
	),
	"jda"
) --}}}

-- End Refactoring --

return snippets, autosnippets
