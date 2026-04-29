if vim.g.neovide then
	vim.g.neovide_fullscreen = true

	vim.api.nvim_create_user_command("NeovideToggleFullscreen", function()
		vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
	end, {})
	vim.api.nvim_create_user_command("NeovideResetZoom", "let g:neovide_scale_factor = 0.65", {})

	local dyn_scale = 1.03
	local change_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end
	vim.keymap.set("n", "<C-=>", function()
		change_scale_factor(dyn_scale)
	end)
	vim.keymap.set("n", "<C-->", function()
		change_scale_factor(1 / dyn_scale)
	end)

	vim.g.neovide_position_animated_length = 0.05
	vim.g.neovide_scroll_animation_length = 0.15
	vim.g.neovide_cursor_animation_length = 0.0

	vim.cmd("NeovideResetZoom")
end
