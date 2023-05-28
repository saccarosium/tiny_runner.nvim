local u = require("code_runner.utils")
local M = {}

function M.split(command, bufname, options)
    local win_id = vim.api.nvim_get_current_win()
    u.term_create(options.term.position, options.term.size)
    vim.fn.termopen(command)
    vim.cmd("norm G")
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    u.buffer_rename(bufname)
    vim.bo.buflisted = false
    if not options.focus then
        vim.fn.win_gotoid(win_id)
    end
    if options.startinsert then
        vim.cmd("startinsert")
    end
end

function M.tab(command, bufname, options)
    vim.cmd("tabnew")
    vim.fn.termopen(command)
    vim.cmd("norm G")
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    u.buffer_rename(bufname)
    if options.startinsert then
        vim.cmd("startinsert")
    end
end

function M.float(command, bufname, options)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "filetype", "crunner")
    local win_height = math.ceil(vim.api.nvim_get_option("lines") * options.float.height - 4)
    local win_width = math.ceil(vim.api.nvim_get_option("columns") * options.float.width)
    local row = math.ceil((vim.api.nvim_get_option("lines") - win_height) * 0.5 - 1)
    local col = math.ceil((vim.api.nvim_get_option("columns") - win_width) * 0.5)
    local opts = {
        style = "minimal",
        relative = "editor",
        border = options.float.border,
        width = win_width,
        height = win_height,
        row = row,
        col = col,
    }
    local win = vim.api.nvim_open_win(buf, true, opts)
    vim.fn.termopen(command)
    if options.startinsert then
        vim.cmd("startinsert")
    end
    vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal")
    vim.api.nvim_win_set_option(win, "winblend", options.float.blend)
end

---@diagnostic disable-next-line: unused-vararg
function M.command(command, ...)
    if vim.fn.empty(command) ~= 1 then
        vim.cmd(command)
    end
end

return M
