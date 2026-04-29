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

local n = #color_priority

function CycleColors(inc)
	local current = vim.g.colors_name
	if current == nil then
		current = "default"
	end

	local next_color
	for i, color in pairs(color_priority) do
		if color == current then
			i = math.fmod(i + inc - 1, n) + 1
			if i == 0 then
				i = n
			end

			next_color = color_priority[i]
		end
	end

	vim.cmd.colorscheme(next_color)
	print(string.format("%s -> %s", current, next_color))
end

vim.cmd.colorscheme(color_priority[1])

vim.keymap.set({ "n", "v" }, "<leader>ccf", function()
	CycleColors(1)
end)
vim.keymap.set({ "n", "v" }, "<leader>ccb", function()
	CycleColors(-1)
end)
vim.keymap.set({ "n", "v" }, "<leader>cr", function()
	vim.cmd.colorscheme(color_priority[1])
end)

vim.api.nvim_create_user_command("CycleColor", function()
	CycleColors(1)
end, {})
