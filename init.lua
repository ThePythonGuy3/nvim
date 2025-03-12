vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd("language en_US")

require("config.lazy")
-- GRUVBOX --
require("gruvbox").setup({
	terminal_colors = true, -- add neovim terminal colors
	undercurl = true,
	underline = true,
	bold = true,
	italic = {
		strings = true,
		emphasis = true,
		comments = true,
		operators = false,
		folds = true,
	},
	strikethrough = true,
	invert_selection = false,
	invert_signs = false,
	invert_tabline = false,
	invert_intend_guides = false,
	inverse = true, -- invert background for search, diffs, statuslines and errors
	contrast = "", -- can be "hard", "soft" or empty string
	palette_overrides = {},
	overrides = {},
	dim_inactive = false,
	transparent_mode = false,
})

-- Dark mode gruvbox
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])


-- NVIM TREE --
vim.opt.termguicolors = true

function getWindowProps()
	local screen_w = vim.opt.columns:get()
	local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
	local w_h = math.floor((screen_w / 3) * 2) 
	local s_h = math.floor((screen_h / 3) * 2) 
	local center_x = (screen_w - w_h) / 2
	local center_y = (screen_h - s_h) / 2 -- ((vim.opt.lines:get() - s_h) / 5) - vim.opt.cmdheight:get()
	return {
		border = "rounded",
		relative = "editor",
		row = center_y,
		col = center_x,
		width = w_h,
		height = s_h,
	}
end

require("window-picker").setup({
	-- type of hints you want to get
	-- following types are supported
	-- "statusline-winbar" | "floating-big-letter" | "floating-letter"
	-- "statusline-winbar" draw on "statusline" if possible, if not "winbar" will be
	-- "floating-big-letter" draw big letter on a floating window
	-- "floating-letter" draw letter on a floating window
	-- used
	hint = require("hint"):new(),

	-- when you go to window selection mode, status bar will show one of
	-- following letters on them so you can use that letter to select the window
	selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",

	-- This section contains picker specific configurations
	picker_config = {
		-- whether should select window by clicking left mouse button on it
		handle_mouse_click = true,
		statusline_winbar_picker = {
			-- You can change the display string in status bar.
			-- It supports "%" printf style. Such as `return char .. ": %f"` to display
			-- buffer file path. See :h "stl" for details.
			selection_display = function(char, windowid)
				return "%=" .. char .. "%="
			end,

			-- whether you want to use winbar instead of the statusline
			-- "always" means to always use winbar,
			-- "never" means to never use winbar
			-- "smart" means to use winbar if cmdheight=0 and statusline if cmdheight > 0
			use_winbar = "never", -- "always" | "never" | "smart"
		},

		floating_big_letter = {
			-- window picker plugin provides bunch of big letter fonts
			-- fonts will be lazy loaded as they are being requested
			-- additionally, user can pass in a table of fonts in to font
			-- property to use instead

			font = "ansi-shadow", -- ansi-shadow |
		},
	},

	-- whether to show "Pick window:" prompt
	show_prompt = true,

	-- prompt message to show to get the user input
	prompt_message = "Pick window: ",

	-- if you want to manually filter out the windows, pass in a function that
	-- takes two parameters. You should return window ids that should be
	-- included in the selection
	-- EX:-
	-- function(window_ids, filters)
	--	-- folder the window_ids
	--	-- return only the ones you want to include
	--	return {1000, 1001}
	-- end
	filter_func = nil,

	-- following filters are only applied when you are using the default filter
	-- defined by this plugin. If you pass in a function to "filter_func"
	-- property, you are on your own
	filter_rules = {
		-- when there is only one window available to pick from, use that window
		-- without prompting the user to select
		autoselect_one = true,

		-- whether you want to include the window you are currently on to window
		-- selection or not
		include_current_win = false,

		-- whether to include windows marked as unfocusable
		include_unfocusable_windows = false,

		-- filter using buffer options
		bo = {
			-- if the file type is one of following, the window will be ignored
			filetype = { "NvimTree", "neo-tree", "notify", "snacks_notif" },

			-- if the file type is one of following, the window will be ignored
			buftype = { "terminal" },
		},

		-- filter using window options
		wo = {},

		-- if the file path contains one of following names, the window
		-- will be ignored
		file_path_contains = {},

		-- if the file name contains one of following names, the window will be
		-- ignored
		file_name_contains = {},
	},

	-- You can pass in the highlight name or a table of content to set as
	-- highlight
	highlights = {
		enabled = true,
		statusline = {
			focused = {
				fg = "#ededed",
				bg = "#e35e4f",
				bold = true,
			},
			unfocused = {
				fg = "#ededed",
				bg = "#44cc41",
				bold = true,
			},
		},
		winbar = {
			focused = {
				fg = "#ededed",
				bg = "#e35e4f",
				bold = true,
			},
			unfocused = {
				fg = "#ededed",
				bg = "#44cc41",
				bold = true,
			},
		},
	},
})

require("nvim-tree").setup({
	filters = {
		dotfiles = true,
		custom = { "node_modules", "\\.cache", ".git", "dist" },
	},
	git = {
		enable = false,
		ignore = true,
	},
	diagnostics = {
		enable = false,
		show_on_dirs = false,
		show_on_open_dirs = false,
		debounce_delay = 500,

		severity = {
			min = vim.diagnostic.severity.HINT,
			max = vim.diagnostic.severity.ERROR,
		},
		icons = {
			hint = "H",
			info = "I",
			warning = "W",
			error = "E",
		},
	},
	sync_root_with_cwd = true,
	log = { enable = false },
	disable_netrw = true,
	hijack_netrw = true,
	hijack_cursor = true,
	hijack_unnamed_buffer_when_opening = false,
	view = {
		float = {
			enable = true,
			open_win_config = getWindowProps(),
		},
		width = function()
			return math.floor(vim.opt.columns:get() * 5)
		end,
	},
	actions = {
		open_file = {
			window_picker = {
				picker = function(conf)
					vim.schedule(function() vim.cmd("NvimTreeClose") end)

					return require("window-picker").pick_window(conf)
				end
			}
		},
	},
	renderer = {
		root_folder_label = true,
		highlight_git = true,
		highlight_opened_files = "none",
		special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "LICENSE", "Dockerfile" },

		indent_markers = {
			enable = true,
			icons = {
				corner = "└",
				edge = "│",
				none = "",
			},
		},

		icons = {
			git_placement = "after",
			modified_placement = "after",
			show = {
				file = true,
				folder = true,
				folder_arrow = false,
				git = true,
			},
		},
	},
})


-- Open NVIM TREE --
vim.cmd(":NvimTreeOpen")
vim.schedule(function()
	vim.cmd("wincmd w")
end)

function updateFloating()
	-- Adjust the floating window position and size
	for _, win_id in ipairs(vim.api.nvim_list_wins()) do
		local win_config = vim.api.nvim_win_get_config(win_id)
		if win_config.relative == "editor" then
			vim.api.nvim_win_set_config(win_id, getWindowProps())
		end
	end
end

vim.keymap.set("n", "t", function()
	vim.cmd(":NvimTreeToggle<CR>")
	updateFloating()
end, { noremap = true, silent = true })

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		if vim.bo.filetype == "NvimTree" then
			local opts = { buffer = true, noremap = true, silent = true }
			-- Remap <Esc> to close NvimTree in normal, insert, and visual mode
			vim.keymap.set({"n", "i", "v"}, "<Esc>", ":NvimTreeToggle<CR>", opts)
		end
	end,
})

function setNumbering()
	vim.wo.number = vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "NvimTree"

	vim.wo.relativenumber = vim.wo.number
	vim.wo.listchars = "tab:| ,space:·"
	vim.wo.list = vim.wo.number
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "*",
	callback = function()
		setNumbering()

		vim.o.statuscolumn = "%s %l %r"
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
	pattern = "*",
	callback = function()
		setNumbering()
		vim.wo.relativenumber = false

		vim.o.statuscolumn = "%s %l"
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		-- Disable line numbers in terminal buffers
		vim.wo.number = false
		vim.wo.relativenumber = false
	end,
})

-- Hook into the VimResized event to adjust the floating window size
vim.api.nvim_create_autocmd("VimResized", {
	callback = updateFloating,
})

-- LUA LINE --
require("lualine").setup()

-- LSP --
local cmp = require("cmp")

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources(
		{
			{ name = "nvim_lsp" },
			{ name = "luasnip" }
		},
		{
			{ name = "buffer" },
		}
	)
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" }
	}
})

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources(
		{
			{ name = "path" }
		},
		{
			{ name = "cmdline" }
		}
	),
	matching = { disallow_symbol_nonprefix_matching = false }
})

-- LSP Servers --

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- CPP --
require("lspconfig")["clangd"].setup {
	capabilities = capabilities,
	filetypes = { "c", "cpp", "cc", "objc", "objcpp", "cuda", "proto", "h", "hpp", "hh" },
	init_options = {
		fallbackFlags = {"--std=c++23"}
	},
}

-- JAVA --
local JDTADDR = "C:\\Program Files\\JDT Java\\"
require("lspconfig")["jdtls"].setup {
	capabilities = capabilities,
	cmd = { "jdtls.bat", "-configuration", "%USERPROFILE%/.cache/jdtls/config", "-data", "%USERPROFILE%/.cache/jdtls/workspace" },
	init_options = {
		jvm_args = {},
		workspace = "%USERPROFILE%/.cache/jdtls/workspace"
	}
}

-- RUST --
require("lspconfig")["rust_analyzer"].setup {
	capabilities = capabilities,
	settings = {
		['rust_analyzer'] = {
			cargo = {
				allFeatures = true,
			},
		},
	},
}

-- Errors on hover --
vim.o.updatetime = 250
vim.api.nvim_create_autocmd("CursorHold", {
	pattern = "*",
	callback = function()
		vim.diagnostic.open_float()
	end,
})

-- CLOSE BRACKETS --
require("autoclose").setup()

-- Config --

vim.keymap.set("t", "<Esc>", "<C-\\><C-N>", { noremap = true, silent = true })

vim.opt.writebackup = false
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.whichwrap = vim.opt.whichwrap + "<,>,[,]"

vim.keymap.set({"n", "i", "v"}, "<C-p>", function() vim.diagnostic.open_float() end, { noremap = true, silent = true })

vim.diagnostic.config({
	update_in_insert = true
})