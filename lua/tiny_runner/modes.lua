local u = require("tiny_runner.utils")
local M = {}

function M.split(task)
    local win_id = vim.api.nvim_get_current_win()
    u.term_create(task.opts.term.position, task.opts.term.size)
    vim.fn.termopen(task.command)
    vim.cmd("norm G")
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    u.buffer_rename(task.name)
    vim.bo.buflisted = false
    if not task.opts.focus then
        vim.fn.win_gotoid(win_id)
    end
    if task.opts.startinsert then
        vim.cmd("startinsert")
    end
end

function M.tab(task)
    vim.cmd("tabnew")
    vim.fn.termopen(task.command)
    vim.cmd("norm G")
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    u.buffer_rename(task.name)
    if task.opts.startinsert then
        vim.cmd("startinsert")
    end
end

function M.float(task)
    local buf = vim.api.nvim_create_buf(false, true)
    u.buffer_rename(task.name)
    local win_height = math.ceil(vim.api.nvim_get_option("lines") * task.options.float.height - 4)
    local win_width = math.ceil(vim.api.nvim_get_option("columns") * task.options.float.width)
    local row = math.ceil((vim.api.nvim_get_option("lines") - win_height) * 0.5 - 1)
    local col = math.ceil((vim.api.nvim_get_option("columns") - win_width) * 0.5)
    local opts = {
        style = "minimal",
        relative = "editor",
        border = task.options.float.border,
        width = win_width,
        height = win_height,
        row = row,
        col = col,
    }
    local win = vim.api.nvim_open_win(buf, true, opts)
    vim.fn.termopen(task.command)
    if task.options.startinsert then
        vim.cmd("startinsert")
    end
    vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal")
    vim.api.nvim_win_set_option(win, "winblend", task.options.float.blend)
end

---@diagnostic disable-next-line: unused-vararg
function M.command(task)
    if vim.fn.empty(task.command) ~= 1 then
        vim.cmd(task.command)
    end
end

return M
