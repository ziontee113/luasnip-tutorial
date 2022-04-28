local cmp = require("cmp")
local luasnip = require("luasnip")

--   פּ ﯟ   some other good icons
local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<A-o>"] = cmp.mapping.select_prev_item(),
		["<A-i>"] = cmp.mapping.select_next_item(),
		["<A-u>"] = cmp.mapping.confirm({ select = true }),
		-- 	["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		-- 	["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		-- 	["<C-i>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		--	["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- 	-- Accept currently selected item. If none selected, `select` first item.
		-- 	-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		-- ["<Space><Space>"] = cmp.mapping.confirm({ select = false }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		-- 	-- ["<Tab>"] = cmp.mapping(function(fallback)
		-- 	-- 	if cmp.visible() then
		-- 	-- 		cmp.select_next_item()
		-- 	-- 	else
		-- 	-- 		fallback()
		-- 	-- 	end
		-- 	-- end, {
		-- 	-- 	"i",
		-- 	-- 	"s",
		-- 	-- }),
		-- 	-- ["<S-Tab>"] = cmp.mapping(function(fallback)
		-- 	-- 	if cmp.visible() then
		-- 	-- 		cmp.select_prev_item()
		-- 	-- 	elseif luasnip.jumpable(-1) then
		-- 	-- 		luasnip.jump(-1)
		-- 	-- 	else
		-- 	-- 		fallback()
		-- 	-- 	end
		-- 	-- end, {
		-- 	-- 	"i",
		-- 	-- 	"s",
		-- 	-- }),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			vim_item.menu = ({
				copilot = "[Copilot]",
				luasnip = "LuaSnip",
				nvim_lua = "[NVim Lua]",
				nvim_lsp = "[LSP]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = {
		{ name = "luasnip" },
		{ name = "copilot" },
		{ name = "nvim_lsp", max_item_count = 6 },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "buffer", max_item_count = 6 },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	-- documentation = {
	-- 	border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	-- },
	-- experimental = {
	-- 	ghost_text = true,
	-- 	native_menu = false,
	-- },
})
