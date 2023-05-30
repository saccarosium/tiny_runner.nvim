local M = {}

---@param name string
function M.buffer_rename(name)
    if vim.fn.empty(name) ~= 1 then
        vim.cmd("file trunner_" .. name)
    end
end

---@param position string
---@param size integer
function M.term_create(position, size)
    vim.cmd(string.format("%s %s new", position, size))
end

---@param command string
---@return boolean
function M.internal_command(command)
    return command ~= nil and command:sub(1, 1) == ":"
end

---@param msg string
function M.error(msg)
    vim.notify("TINY RUNNER: " .. msg, vim.log.levels.ERROR)
end

return M
