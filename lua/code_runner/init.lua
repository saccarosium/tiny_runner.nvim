local o = require("code_runner.options")
local u = require("code_runner.utils")
local api = require("code_runner.api")
local prefix = "crunner_"

local M = {}

---@param options table?
M.setup = function(options)
    o.set(options or {})
end

---@param mode string
function M.project_run(mode)
    local project = api.project_get_current()
    if not project then
        error("Did found a project configuration for current directory")
        return
    end
    if vim.fn.empty(mode) == 1 then
        mode = project.mode
    end
    project.name = project.name or ""
    if u.internal_command(project.command) then
        mode = "command"
    end
    M.file_run(project.command, mode)
end

---@param command string?
---@param bufname string?
---@param mode string?
function M.file_run(command, bufname, mode)
    local opt = o.get()
    local exec = nil
    if vim.fn.empty(command) == 1 then
        command = api.file_get_current_command()
    end
    if not command then
        error("Didn't found a command for current filetype")
        return
    end
    if u.internal_command(command) then
        mode = "command"
    end
    mode = mode or opt.mode
    bufname = bufname or ""
    bufname = prefix .. bufname
    exec = api.mode_get(mode)
    if not exec then
        error("Selected mode is not valid (:h code_runner-modes)")
        return
    end
    exec(command, bufname, opt)
end

---@param bufname string
function M.close_runner(bufname)
    bufname = bufname or prefix .. vim.fn.expand("%:t:r")
    local current_buf = vim.fn.bufname()
    if string.find(current_buf, prefix) then
        vim.cmd("bwipeout!")
    else
        local bufid = vim.fn.bufnr(bufname)
        if bufid ~= -1 then
            vim.cmd("bwipeout!" .. bufid)
        end
    end
end

return M
