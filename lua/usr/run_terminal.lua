-- local run_cmd = ""
-- local prefix = "RUN_NEOVIDE_STARTUP_.*"
--
--
-- -- local argv = vim.v.argv
-- local argc = { "nvim", "RUN_" }
--
-- for _, v in ipairs(argv) do
-- 	if string.match(v, prefix) then
-- 		run_cmd = v:sub(#prefix + 1)
-- 		break
-- 	end
-- end
--
-- if #run_cmd ~= 0 then
--     vim.cmd.echo("\"" .. run_cmd .. "\"")
-- 	-- vim.fn.jobstart("pyc", {
-- 	-- 	term = true,
-- 	-- 	on_exit = function(job_id, code, event)
-- 	-- 		vim.cmd.qa()
-- 	-- 	end,
-- 	-- })
-- end

vim.fn.jobstart("pyc", {
    term = true,
    on_exit = function(job_id, code, event)
        vim.cmd.qa()
    end,
})
