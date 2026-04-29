return {
	make_fully_relative = function(cwd, path, count)
		local Path = require("plenary.path")
		cwd = Path:new(cwd):absolute()
		path = Path:new(path):absolute()

		local relparts = vim.fn.split(path, "/")
		local cwdparts = vim.fn.split(cwd, "/")

		while (#relparts > 0 and #cwdparts > 0) and (relparts[1] == cwdparts[1]) do
			table.remove(relparts, 1)
			table.remove(cwdparts, 1)
		end

		local updirs = vim.fn.split(string.rep("..", #cwdparts, "/"), "/")
		relparts = table.move(relparts, 1, #relparts, #updirs + 1, updirs)

		count = count or #relparts
		if count == 0 then
			count = 1
		end
		if count > #relparts then
			count = #relparts
		end

		return table.concat(relparts, "/", 1, count)
	end,
}
