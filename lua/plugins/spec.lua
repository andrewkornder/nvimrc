local lsp_servers = {
	"clangd",
	"jdtls",
	"jsonls",
	"lua_ls",
	"pylsp",
	"rust_analyzer",
	"ts_ls",
	"vimls",
}

local lsp_settings = {}
local lsp_on_attach = {}

return {
	{
		"https://github.com/olimorris/onedarkpro.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			highlights = {
				-- ["@punctuation.bracket"] = { fg = "${red}" },
			},
		},
	},
	{ "sainnhe/gruvbox-material", lazy = false, priority = 900 },
	{ "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 900 },
	{ "Mofiqul/dracula.nvim", name = "dracula", lazy = false, priority = 900 },
	{ "folke/tokyonight.nvim", lazy = false, priority = 900 },
	{ "wilmanbarrios/palenight.nvim", lazy = false, priority = 900 },

	{ "nvim-lua/plenary.nvim", lazy = false, priority = 900 },

	{
		"willothy/flatten.nvim",
		opts = {},
		lazy = false,
		priority = 1001,
	},

	{
		"smjonas/inc-rename.nvim",
		opts = {},
	},
	{
		"NStefan002/screenkey.nvim",
		lazy = false,
		version = "*", -- or branch = "main", to use the latest commit
		opts = {},
		setup = function()
			vim.cmd("Screenkey")
		end,
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			explorer = { enabled = true, replace_netrw = false },
			indent = { enabled = true },
			image = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			words = { enabled = true },
		},
		keys = {
			{
				"<leader>e",
				function()
					Snacks.explorer()
				end,
				desc = "File Explorer",
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end

					-- Override print to use snacks for `:=` command
					if vim.fn.has("nvim-0.11") == 1 then
						vim._print = function(_, ...)
							dd(...)
						end
					else
						vim.print = _G.dd
					end

					-- Create some toggle mappings
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle.line_number():map("<leader>ul")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>uc")
					Snacks.toggle.treesitter():map("<leader>uT")
					Snacks.toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<leader>ub")
					Snacks.toggle.inlay_hints():map("<leader>uh")
					Snacks.toggle.indent():map("<leader>ug")
					Snacks.toggle.dim():map("<leader>uD")
				end,
			})
		end,
	},

	{
		"rmagatti/auto-session",
		dependencies = { "nvim-telescope/telescope.nvim" },
		lazy = false,

		---enables autocomplete for opts
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			lazy_support = true,
			auto_restore_last_session = false,
			args_allow_files_auto_save = true,
			show_auto_restore_notif = true,
		},
	},

	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			files = {
				fd_opts = [[--color=never --hidden -t f -t l -t d  -E .git -E build -E .o -E .d]],
				rg_opts = [[--color=never --hidden --type f --type l --exclude .git --pcre2]],
			},
			grep = {
				grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
				rg_opts = "--pcre2 --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
			},
			previewers = {
				builtin = {
					extensions = {
						["png"] = { "chafa" },
						["jpg"] = { "chafa" },
						["jpeg"] = { "chafa" },
						["gif"] = { "chafa" },
					},
					ueberzug_port = nil, -- Only needed if using ueberzug
				},
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local runtime_path = vim.fn.stdpath("state") .. "/nvim-treesitter"
			vim.opt.runtimepath:append(runtime_path)
			require("nvim-treesitter.config").setup({
				install_dir = runtime_path,
				ensure_installed = {
					"asm",
					"bash",
					"c",
					"cmake",
					"cpp",
					"css",
					"cuda",
					"fish",
					"html",
					"java",
					"javascript",
					"json",
					"latex",
					"llvm",
					"lua",
					"make",
					"markdown",
					"markdown_inline",
					"norg",
					"python",
					"regex",
					"rust",
					"scss",
					"svelte",
					"tsx",
					"typescript",
					"typst",
					"vim",
					"vue",
				},
				sync_install = false,
				ignore_install = {},
				modules = {},
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = true,
				},
			})
		end,
	},

	{
		"mason-org/mason.nvim",
		config = true,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = true,
	},
	{
		"neovim/nvim-lspconfig",
		config = function() end,
		init = function()
			local lspCapabilities = vim.lsp.protocol.make_client_capabilities()

			-- Enable snippets-completion (for nvim_cmp)
			lspCapabilities.textDocument.completion.completionItem.snippetSupport = true

			-- Enable folding (for nvim-ufo)
			lspCapabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = false,
			}

			for _, lsp in pairs(lsp_servers) do
				local config = {
					capabilities = lspCapabilities,
					settings = lsp_settings[lsp], -- if no settings, will assign nil and therefore do nothing
					on_attach = lsp_on_attach[lsp], -- mostly disables some settings
				}

				vim.lsp.config(lsp, config)
			end
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader><leader>",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		-- This will provide type hinting with LuaLS
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				cpp = { "clang-format", stop_after_first = true },
				lua = { "stylua" },
				python = { "ruff_format" },
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- Set up format-on-save
			-- format_on_save = { timeout_ms = 1000 },
			-- Customize formatters
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		},
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
	{
		"linux-cultist/venv-selector.nvim",
		branch = "main",
		dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
		opts = {
			name = { ".venv", "venv", "virtualenv" },
			auto_refresh = true,
			dap_enabled = true,
		},
		event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
		keys = {
			-- Keymap to open VenvSelector to pick a venv.
			{ "<leader>vs", "<cmd>VenvSelect<cr>" },
			-- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
			{ "<leader>vc", "<cmd>VenvSelectCached<cr>" },
		},
	},

	{
		"echasnovski/mini.surround",
		opts = {
			mappings = {
				add = "<leader>sa", -- Add surrounding in Normal and Visual modes
				delete = "<leader>sd", -- Delete surrounding
				find = "<leader>sf", -- Find surrounding (to the right)
				find_left = "<leader>sF", -- Find surrounding (to the left)
				highlight = "<leader>sh", -- Highlight surrounding
				replace = "<leader>sr", -- Replace surrounding
				update_n_lines = "<leader>sn", -- Update `n_lines`

				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
			respect_selection_type = true,
		},
	},

	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
			sticky = false,
		},
	},

	{
		"https://github.com/cohama/lexima.vim",
		config = function()
			vim.g.lexima_enable_basic_rules = 1
			vim.g.lexima_enable_newline_rules = 1
			vim.g.lexima_enable_endwise_rules = 1
		end,
	},

	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>tx",
				"<cmd>Trouble diagnostics toggle win.position=right win.size=0.4<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>tb",
				"<cmd>Trouble diagnostics toggle filter.buf=0 win.position=right win.size=0.4<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>ts",
				"<cmd>Trouble symbols toggle focus=false win.position=right win.size=0.4<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>tr",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>tl",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>tq",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	{
		"madskjeldgaard/cppman.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			local cppman = require("cppman")
			cppman.setup()

			-- Make a keymap to open the word under cursor in CPPman
			vim.keymap.set("n", "/cm", function()
				cppman.open_cppman_for(vim.fn.expand("<cword>"))
			end)

			-- Open search box
			vim.keymap.set("n", "/cc", function()
				cppman.input()
			end)
		end,
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		config = function()
			-- triggers CursorHold event faster
			vim.opt.updatetime = 200

			require("barbecue").setup({
				create_autocmd = false,
			})

			vim.api.nvim_create_autocmd({
				"WinResized",
				"BufWinEnter",
				"CursorHold",
				"InsertLeave",

				-- include this if you have set `show_modified` to `true`
				"BufModifiedSet",
			}, {
				group = vim.api.nvim_create_augroup("barbecue.updater", {}),
				callback = function()
					require("barbecue.ui").update()
				end,
			})
		end,
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 30
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			open_mapping = "<C-t>",
		},
	},
	{
		"https://codeberg.org/andyg/leap.nvim",
		dependencies = { "tpope/vim-repeat" },
		lazy = false,
		config = function()
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
			vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-from-window)")
			vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-cross-window)")

			require("leap").opts.preview_filter = function(ch0, ch1, ch2)
				return not (ch1:match("%s") or ch0:match("%a") and ch1:match("%a") and ch2:match("%a"))
			end
			require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
			require("leap.user").set_repeat_keys("<enter>", "<backspace>")
		end,
	},
	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_view_method = "zathura"
		end,
	},
	{
		"samjwill/nvim-unception",
	},
}
