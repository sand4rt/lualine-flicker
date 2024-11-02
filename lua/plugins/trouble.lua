return {
    "folke/trouble.nvim",
    keys = {
        {
            "<leader>x",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "trouble: toggle diagnostics quickfix",
        },
        {
            "<leader>q",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "trouble: toggle quickfix",
        },
        {
            "[q",
            function()
                if require("trouble").is_open() then
                    require("trouble").prev()
                else
                    local ok, err = pcall(vim.cmd.cprev)
                    if not ok then
                        vim.notify(err, vim.log.levels.ERROR)
                    end
                end
            end,
            desc = "trouble: previous quickfix",
        },
        {
            "]q",
            function()
                if require("trouble").is_open() then
                    require("trouble").next()
                else
                    local ok, err = pcall(vim.cmd.cnext)
                    if not ok then
                        vim.notify(err, vim.log.levels.ERROR)
                    end
                end
            end,
            desc = "trouble: next quickfix",
        },
    },
    opts = {
        auto_close = true, -- auto close when there are no items
        auto_open = false, -- auto open when there are items
        auto_preview = false, -- automatically open preview when on an item
        auto_refresh = true, -- auto refresh when open
        focus = true, -- Focus the window when opened
        restore = true, -- restores the last location in the list when opening
        follow = true, -- Follow the current item
        indent_guides = true, -- show indent guides
        max_items = 200, -- limit number of items that can be displayed per section
        multiline = true, -- render multi-line messages
        pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
        win = {
            size = {
                height = 20,
            },
        },
        -- Window options for the preview window. Can be a split, floating window, or `main`
        preview = { type = "main" },
        throttle = {
            refresh = 20, -- fetches new data when needed
            update = 10, -- updates the window
            render = 10, -- renders the window
            follow = 10, -- follows the current item
            preview = { ms = 100, debounce = true }, -- shows the preview for the current item
        },
        keys = {
            ["?"] = "help",
            r = "refresh",
            R = "toggle_refresh",
            q = "cancel",
            o = "jump_close",
            ["<esc>"] = "close",
            ["<cr>"] = "jump",
            ["<2-leftmouse>"] = "jump",
            ["<c-s>"] = "jump_split",
            ["<c-v>"] = "jump_vsplit",
            -- go down to next item (accepts count)
            -- j = "next",
            ["}"] = "next",
            ["]]"] = "next",
            -- go up to prev item (accepts count)
            -- k = "prev",
            ["{"] = "prev",
            ["[["] = "prev",
            i = "inspect",
            p = "preview",
            P = "toggle_preview",
            zo = "fold_open",
            zO = "fold_open_recursive",
            zc = "fold_close",
            zC = "fold_close_recursive",
            za = "fold_toggle",
            zA = "fold_toggle_recursive",
            zm = "fold_more",
            zM = "fold_close_all",
            zr = "fold_reduce",
            zR = "fold_open_all",
            zx = "fold_update",
            zX = "fold_update_all",
            zn = "fold_disable",
            zN = "fold_enable",
            zi = "fold_toggle_enable",
        },
        modes = {
            symbols = {
                desc = "document symbols",
                mode = "lsp_document_symbols",
                focus = false,
                win = { position = "right" },
                filter = {
                    -- remove Package since luals uses it for control flow structures
                    ["not"] = { ft = "lua", kind = "Package" },
                    any = {
                        -- all symbol kinds for help / markdown files
                        ft = { "help", "markdown" },
                        -- default set of symbol kinds
                        kind = {
                            "Class",
                            "Constructor",
                            "Enum",
                            "Field",
                            "Function",
                            "Interface",
                            "Method",
                            "Module",
                            "Namespace",
                            "Package",
                            "Property",
                            "Struct",
                            "Trait",
                        },
                    },
                },
            },
        },
        icons = {
            indent = {
                top = "│ ",
                middle = "├╴",
                last = "└╴",
                fold_open = "  ",
                fold_closed = "  ",
                ws = "  ",
            },
            folder_closed = require("../variables").folders.folder_closed .. " ",
            folder_open = require("../variables").folders.folder_closed .. " ",
            kinds = require("../variables").icons,
        },
    },
}
