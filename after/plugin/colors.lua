vim.opt.background = "dark"

local overrideColors = {
	bg = { "#16161D", "234" }, --eigengrau
	-- bg = { "#161820", "234" },
	stsln = { "#1b1e26", "235" },
}

vim.g.gruvbox_material_background = "soft"
vim.g.gruvbox_material_better_performance = 1

vim.g.gruvbox_material_colors_override = {
	bg0 = overrideColors.bg,
	bg1 = overrideColors.stsln,
	bg2 = overrideColors.stsln,
	bg_statusline1 = overrideColors.stsln,
}

local color_priority = {
	"onedark",
	"gruvbox-material",
	"dracula",
	"tokyonight",
	"rose-pine",
	"palenight",
	"default",
}

vim.cmd.colorscheme(color_priority[1])
