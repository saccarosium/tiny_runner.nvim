local opt = {
    mode = "term",
    focus = true,
    startinsert = true,
    term = {
        position = "bot",
        size = 20,
    },
    float = {
        -- Window border (see ':h nvim_open_win')
        border = "rounded",
        -- Num from `0 - 1` for measurements
        height = 0.8,
        width = 0.8,
        -- Transparency (see ':h winblend')
        blend = 0,
    },
    filetypes = {
        javascript = "node",
        java = "javac % && java %<",
        c = "gcc % && %:h/a.out",
        cpp = "g++ % && %:h/a.out",
        python = "python -u",
        sh = "bash",
        rust = "rustc % && %<",
        lua = ":luafile %",
        vim = ":source %",
    },
    projects = {},
}

local M = {}

---@param options table
M.set = function(options)
    opt = vim.tbl_deep_extend("force", opt, options)
end

---@return table
M.get = function()
    return opt
end

return M
