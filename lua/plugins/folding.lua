local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = (" - %d "):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, "MoreMsg" })
	return newVirtText
end

vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.o.nu = true

return {
	{
		"luukvbaal/statuscol.nvim",
		enabled = true,
		lazy = false,
		-- init = function()
		-- 	vim.o.fillchars = "eob: ,fold: ,foldopen: ,foldsep: ,foldclose: " -- Customize fold marks, alt = +,-
		-- end,
		-- opts = function()
		-- 	local builtin = require("statuscol.builtin")
		-- 	return {
		-- 		setopt = true,
		-- 		segments = {
		-- 			{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
		-- 			{ text = { "%s" }, click = "v:lua.ScSa" },
		-- 			{
		-- 				text = { builtin.lnumfunc, " " },
		-- 				condition = { true, builtin.not_empty },
		-- 				click = "v:lua.ScLa",
		-- 			},
		-- 		},
		-- 	}
		-- end,
		opts = function()
			local builtin = require("statuscol.builtin")
			return {
				setopt = true,
				relculright = true,
				segments = {

					{ text = { builtin.foldfunc }, click = "v:lua.ScFa", hl = "Comment" },
					{ text = { "%s" }, click = "v:lua.ScSa" },
					{ text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
				},
			}
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		lazy = false,
		dependencies = { "kevinhwang91/promise-async" },
		opts = {
			fold_virt_text_handler = handler,
			provider_selector = function(bufnr, filetype, buftype)
				return { "lsp", "indent" }
			end,
			open_fold_hl_timeout = 500,
			-- open opening the buffer, close these fold kinds
			-- use `:UfoInspect` to get available fold kinds from the LSP
			close_fold_kinds = { "comment", "imports" },
		},
		config = function()
			vim.api.nvim_create_autocmd("BufEnter", { callback = require("ufo").enable })
			vim.keymap.set("n", "zz", require("ufo").peekFoldedLinesUnderCursor)

			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

			vim.keymap.set("n", "zx", "zo")
		end,
	},
}
