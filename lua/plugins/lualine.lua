local function is_new_file()
	local filename = vim.fn.expand("%")
	return filename ~= ""
		and filename:match("^%a+://") == nil
		and vim.bo.buftype == ""
		and vim.fn.filereadable(filename) == 0
end

local function get_name()
	local symbol_lut = {
		modified = "[+]",
		readonly = "[-]",
		unnamed = "[No Name]",
		newfile = "[New]",
	}

	local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
	local fp = vim.fn.expand("%:p")
	if vim.fn.isdirectory(fp) == 1 then
		fp = fp .. "/"
	end

	if fp == "" then
		fp = " " .. symbol_lut.unnamed
	end

	if cwd ~= "/" then
		cwd = string.sub(cwd, 1, #cwd - 1)
		fp = require("utils").make_fully_relative(cwd, fp)

		local repeated = 0

		while string.sub(fp, 1, 3) == "../" do
			repeated = repeated + 1
			fp = string.sub(fp, 4, #fp)
		end

		if repeated > 1 then
			fp = string.format("[.. x %d]/", repeated) .. fp
		else
			fp = string.rep("../", repeated) .. fp
		end

		cwd = string.gsub(cwd .. "/", "^" .. vim.fn.expand("$HOME/"), "~/")
		cwd = string.sub(cwd, 1, #cwd - 1)
	else
		fp = string.sub(fp, 2, #fp)
	end

	if fp ~= "" then
		fp = " " .. fp
	end

	local name = "<" .. vim.api.nvim_get_current_buf() .. "> (" .. cwd .. ")" .. fp
	local symbols = {}
	if vim.bo.modified then
		table.insert(symbols, symbol_lut.modified)
	end
	if vim.bo.modifiable == false or vim.bo.readonly == true then
		table.insert(symbols, symbol_lut.readonly)
	end
	if is_new_file() then
		table.insert(symbols, symbol_lut.newfile)
	end

	if #symbols == 0 then
		return name
	else
		return name .. " " .. table.concat(symbols, "")
	end
end

local opts = {
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = false,
		refresh = {
			statusline = 100,
			tabline = 100,
			winbar = 100,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			{ get_name },
		},

		lualine_x = { "os.date('%x')", "os.date('%X')", "encoding", "fileformat", "filetype" },
		lualine_y = { "selectioncount", "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = { "diagnostics" },
		lualine_c = {
			{ get_name },
		},
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {
		lualine_a = {
			{
				"tabs",
				mode = 1,
				path = 3,
				max_length = function()
					return 2 * vim.o.columns / 3
				end,
			},
		},
		lualine_b = {},
		lualine_c = {},

		lualine_x = {},
		lualine_y = { "windows" },
		lualine_z = {
			{
				function()
					return "🗖"
				end,
				cond = function()
					return vim.g.neovide ~= nil
				end,
				on_click = function(_, button, _)
					if button == "l" then
						vim.cmd("NeovideToggleFullscreen")
					end
				end,
				color = { bg = "grey", fg = "black" },
			},
			{
				function()
					return "[X]"
				end,
				on_click = function(_, button, _)
					if button == "l" then
						vim.cmd("qa!")
					end
				end,
				color = { bg = "red", fg = "black", gui = "bold" },
			},
		},
	},
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = opts,
	extensions = { "fzf", "lazy", "mason", "trouble" },
}
