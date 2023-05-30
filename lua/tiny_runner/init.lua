local o = require("tiny_runner.options")
local u = require("tiny_runner.utils")
local api = require("tiny_runner.api")

local M = {}

---@param options table?
M.setup = function(options)
    o.set(options or {})
end

---@param task table
function M.run(task)
    if not task then
        u.error("Can't run task because got nil")
        return
    end
    if u.internal_command(task.command) then
        task.mode = "command"
    end
    local exec = api.mode_get(task.mode)
    if not exec then
        u.error("Selected mode is not valid (:h tiny_runner-modes)")
        return
    end
    exec(task)
end

---@param mode string?
function M.project_run(mode)
    local task = {}
    local project = api.project_get_current()
    if not project then
        u.error("Didn't found a project configuration for current directory")
        return
    end
    if mode then
        project.mode = mode
    end
    task = project
    task.opts = o.get()
    M.run(task)
end

---@param mode string?
function M.file_run(mode)
    local task = {}
    task.opts = o.get()
    task.command = api.file_get_current_command()
    if not task.command then
        u.error("Didn't found a command for current filetype")
        return
    end
    task.mode = mode or task.opts.mode
    task.name = vim.bo.filetype
    M.run(task)
end

return M
