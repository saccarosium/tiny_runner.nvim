local o = require("code_runner.options")
local m = require("code_runner.modes")
local M = {}

local modes = {
    tab = m.tab,
    term = m.split,
    float = m.float,
    command = m.command,
}

---@param mode table
function M.mode_register(mode)
    if not vim.tbl_isempty(mode) then
        modes = vim.tbl_deep_extend("force", modes, mode)
    end
end

---@param mode string
---@return function?
function M.mode_get(mode)
    return modes[mode]
end

---@return table?
function M.project_get_current()
    local projects = o.get().projects
    if vim.tbl_isempty(projects) then
        error("Doesn't seem you have any project defined")
        return
    end
    local paths = vim.tbl_keys(projects)
    local cwd = vim.loop.cwd()
    local project = nil
    for _, path in ipairs(paths) do
        if cwd == vim.fn.expand(path) then
            project = projects[path]
            project.path = path
            project.command = vim.fn.expandcmd(project.command)
            return project
        end
    end
end

---@param path string
---@return table?
function M.project_get(path)
    local projects = o.get().projects
    local project = nil
    if vim.tbl_isempty(projects) then
        error("Doesn't seem you have any project defined")
        return
    end
    project = projects[path]
    if not project then
        error("Didn't found any project associated with this path")
        return
    end
    project.path = path
    project.command = vim.fn.expandcmd(project.command)
    return project
end

---@param filetype string?
---@return string?
function M.file_get_filetype_command(filetype)
    local opt = o.get()
    local command = opt.filetypes[filetype]
    if command then
        return vim.fn.expandcmd(command)
    end
end

---@return string?
function M.file_get_current_command()
    local opt = o.get()
    local filetype = vim.bo.filetype
    local command = opt.filetypes[filetype]
    if command then
        return vim.fn.expandcmd(command)
    end
end

return M
