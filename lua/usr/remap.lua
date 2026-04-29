local set = vim.keymap.set

-- better navigation
-- set("i", "<Down>", "<Esc>gjli", { desc = "Move down by display line" })
-- set("i", "<Up>", "<Esc>gkli", { desc = "Move up by display line" })
set({ "n", "v" }, "<Down>", "gj", { desc = "Move down by display line" })
set({ "n", "v" }, "<Up>", "gk", { desc = "Move up by display line" })
set({ "n", "v" }, "j", "gj", { desc = "Move down by display line" })
set({ "n", "v" }, "k", "gk", { desc = "Move up by display line" })

set("n", "<leader>ex", vim.cmd.Ex)

-- navigate tabs
set({"n", "t", "v"}, "<C-Tab>", vim.cmd.tabnext)
set({"n", "t", "v"}, "<C-S-Tab>", vim.cmd.tabprevious)

-- reload buffer
set("n", "<leader>r", [[<cmd>e %<CR>]])

-- move selected line up or down
set("v", "J", ":m '>+1<CR>gv=gv")
set("v", "K", ":m '<-2<CR>gv=gv")

-- paste over selected text
set("x", "<leader>p", [["_dP]])

-- copy into sys register and paste from
set("v", "<C-c>", [["+y]])
set("n", "<leader>y", [[^v$h"+y]])
set("i", "<C-v>", [[<Esc>"+pli]])
set("n", "<C-v>", [["+p]])

-- copy all of file
set({ "n", "v", "i" }, "<C-a>", [[ggVG"+y]])

-- actually delete text w/o copying
set({ "n", "v" }, "d", [["_d]])

-- exit terminal w <Esc>
set("t", "<Esc>", [[<C-\><C-n>]])

-- better clearing of terminal
local term_clear = function()
	vim.fn.feedkeys("", "n")
	local sb = vim.bo.scrollback
	vim.bo.scrollback = 1
	vim.bo.scrollback = sb
end

set("t", "<C-L>", "<Esc>zt8<C-e>")
set("n", "<C-L>", "zt8<C-e>")

set("t", "<C-l>", term_clear)
set("n", "<C-l>", function()
	if string.sub(vim.fn.expand("%"), 1, 7) == "term://" then
		vim.fn.feedkeys("i", "n")
		term_clear()
		local keys = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
		vim.fn.feedkeys(keys .. "li" .. keys, "m")
	end
end)

-- quickfix binds
set("n", "<C-k>", "<cmd>cnext<CR>zz")
set("n", "<C-j>", "<cmd>cprev<CR>zz")
set("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")

-- search and replace for current word
set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
set("n", "<leader>f", [[?\<<C-r><C-w>\>]])

-- easy quitting vim
local function quit()
	vim.cmd("SaveSession! default")
	-- wfmt()
	vim.cmd.qa()
end
set("n", "<F4>", quit)

-- changing cwd easier
set("n", "<leader>cd", "<cmd>cd %:p:h<CR>")
set("n", "==", function()
	local count = vim.v.count
	if count == 0 then
		count = 1
	end
	vim.cmd.cd(string.rep("..", count, "/"))
end)
set("n", "++", function()
	local path = require("utils").make_fully_relative(
		vim.fn.fnamemodify(vim.fn.getcwd(), ":p"),
		vim.fn.expand("%:p:h"),
		vim.v.count
	)
	if path ~= "" then
		vim.cmd.cd(path)
	end
end)

-- open nvim configs
local config = vim.fn.stdpath("config")
local function open_folder(map, path)
	set("n", map, "<cmd>tabnew | " .. "cd " .. path .. " | e .<CR>gg8j")
end
open_folder("<leader>cf", config)
open_folder("<leader>cc", vim.user.code)
open_folder("<leader>ct", "~/.config/fish")

-- typos i make a lot with shift
vim.api.nvim_create_user_command("E", "e", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wa", "wa", {})
vim.api.nvim_create_user_command("Vs", "vs", {})
vim.api.nvim_create_user_command("Q", "q", {})

-- copy path to file
set("n", "<leader>cp", function()
	local path = '"' .. string.gsub(vim.fn.expand("%:p"), "\\", "/") .. '"'
	vim.fn.setreg('"', path)
end)
set("n", "<leader>cP", function()
	local path = '"' .. string.gsub(vim.fn.expand("%:p"), "\\", "/") .. '"'
	vim.fn.setreg("+", path)
end)

-- fuzzy finder
set({ "n", "v" }, "<leader>fs", "<cmd>FzfLua live_grep_native<CR>", { silent = true, desc = "grep in files" })
set({ "v" }, "<leader>fw", "<cmd>FzfLua grep_visual<CR>", { silent = true, desc = "grep for selection in files" })

set({ "n" }, "<leader>fw", "<cmd>FzfLua grep_cword<CR>", { silent = true, desc = "grep for word in files" })

set({ "n", "v" }, "<leader>fF", function()
	require("fzf-lua").files({ hidden = true })
end, { silent = true, desc = "fuzzy complete path (with hidden files)" })

set({ "n", "v" }, "<leader>ff", function()
	require("fzf-lua").files({ hidden = false })
end, { silent = true, desc = "fuzzy complete path (without hidden files)" })

set({ "n", "v" }, "<leader>fb", "<cmd>FzfLua buffers<CR>", { silent = true, desc = "fuzzy complete buffer" })

set({ "n" }, "<leader>fl", "<cmd>FzfLua blines<CR>", { silent = true, desc = "fuzzy line finding" })

set({ "n", "v" }, "<leader>fk", "<cmd>FzfLua lsp_finder<CR>", { silent = true, desc = "find lsp" })

set({ "n" }, "<leader>fcp", "<cmd>FzfLua complete_path<CR>", { silent = true, desc = "complete path under cursor" })

set({ "n" }, "<leader>fcf", "<cmd>FzfLua complete_file<CR>", { silent = true, desc = "complete file under cursor" })

set({ "n" }, "<leader>op", function()
	vim.fn.jobstart("open_in_explorer", {
		cwd = vim.fn.getcwd(),
	})
end)
set({ "n" }, "<leader>tm", function()
	vim.fn.jobstart("start_new_wsl_shell", {
		cwd = vim.fn.stdpath("config"),
	})
end)

set({ "n" }, "<leader>md", [[<cmd>vs<cr><C-w>l<cmd>term fd -e md | entr -c glow /_<cr><C-w>h]])

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function(event)
		set(
			"n",
			"<leader>vv",
			"<cmd>VimtexView<CR>",
			{ silent = true, desc = "scroll buffer and viewer to cursor", buffer = event.buf }
		)
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})
