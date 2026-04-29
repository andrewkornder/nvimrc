vim.user = {
	code = "~/code",
	uv = "uv",
    python = "~/.venv/bin/python",
    cxx = "clang++",
	cc = "clang"
}

vim.api.nvim_create_user_command("Info", function() vim.print(vim.user) end, {})
