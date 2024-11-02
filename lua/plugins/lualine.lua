return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    branch = "fix/flickering",
    config = function()
        local colors = require("vscode.colors").get_colors()

        local function should_ignore_filetype()
            local ft = vim.bo.filetype
            return ft == "alpha"
                or ft == "lazy"
                or ft == "mason"
                or ft == "neo-tree"
                or ft == "TelescopePrompt"
                or ft == "fugitive"
                or ft == "lazygit"
                or ft == "DiffviewFiles"
                or ft == "spectre_panel"
                or ft == "sagarename"
                or ft == "sagafinder"
                or ft == "saga_codeaction"
                or ft == "toggleterm"
                or ft == "gitcommit"
                or ft == "trouble"
                or ft == "copilot-chat"
                or ft == "qf"
                or ft == "dapui_watches"
                or ft == "dapui_scopes"
                or ft == "dapui_stacks"
                or ft == "dapui_breakpoints"
                or ft == "undotree"
                or ft == "neotest-summary"
                or ft == "dbui"
                or ft == ""
        end

        local function diagnostics_component()
            local diagnostics = require("lualine.components.filename"):extend()

            function diagnostics:init(options)
                diagnostics.super.init(self, options)

                self.diagnostics = {
                    sections = options.sections,
                    symbols = options.symbols,
                    last_results = {},
                    highlight_groups = {
                        error = self:create_hl(options.colors.error, "error"),
                        warn = self:create_hl(options.colors.warn, "warn"),
                        info = self:create_hl(options.colors.info, "info"),
                        hint = self:create_hl(options.colors.hint, "hint"),
                    },
                }
            end

            function diagnostics:update_status()
                local context = {
                    BUFFER = "buffer",
                    WORKSPACE = "workspace",
                }

                local function count_diagnostics(ctx, severity)
                    local bufnr

                    if ctx == context.BUFFER then
                        bufnr = 0
                    elseif ctx == context.WORKSPACE then
                        bufnr = nil
                    else
                        vim.print("Unexpected diagnostics context: " .. ctx)
                        return nil
                    end

                    local total = vim.diagnostic.get(bufnr, { severity = severity })

                    return vim.tbl_count(total)
                end

                local function get_diagnostic_results()
                    local severity = vim.diagnostic.severity

                    local results = {}

                    local eb = count_diagnostics(context.BUFFER, severity.ERROR)
                    local ew = count_diagnostics(context.WORKSPACE, severity.ERROR)
                    if eb > 0 or ew > 0 then
                        results.error = { eb, ew }
                    else
                        results.error = nil
                    end

                    local wb = count_diagnostics(context.BUFFER, severity.WARN)
                    local ww = count_diagnostics(context.WORKSPACE, severity.WARN)
                    if wb > 0 or ww > 0 then
                        results.warn = { wb, ww }
                    else
                        results.warn = nil
                    end

                    local ib = count_diagnostics(context.BUFFER, severity.INFO)
                    local iw = count_diagnostics(context.WORKSPACE, severity.INFO)
                    if ib > 0 or iw > 0 then
                        results.info = { ib, iw }
                    else
                        results.info = nil
                    end

                    local hb = count_diagnostics(context.BUFFER, severity.HINT)
                    local hw = count_diagnostics(context.WORKSPACE, severity.HINT)
                    if hb > 0 or hw > 0 then
                        results.hint = { hb, hw }
                    else
                        results.hint = nil
                    end

                    for _, v in pairs(results) do
                        if v ~= nil then
                            return results
                        end
                    end

                    return nil
                end

                local output = { "  " }

                local bufnr = vim.api.nvim_get_current_buf()

                local diagnostics_results
                if vim.api.nvim_get_mode().mode:sub(1, 1) ~= "i" or should_ignore_filetype() then
                    diagnostics_results = get_diagnostic_results()
                    self.diagnostics.last_results[bufnr] = diagnostics_results
                else
                    diagnostics_results = self.diagnostics.last_results[bufnr]
                end

                if diagnostics_results == nil then
                    return ""
                end

                local lualine_utils = require("lualine.utils.utils")

                local backgrounds = {}
                for name, hl in pairs(self.diagnostics.highlight_groups) do
                    colors[name] = self:format_hl(hl)
                    backgrounds[name] = lualine_utils.extract_highlight_colors(colors[name]:match("%%#(.-)#"), "bg")
                end

                local previous_section, padding

                for _, section in ipairs(self.diagnostics.sections) do
                    if diagnostics_results[section] ~= nil then
                        padding = previous_section and (backgrounds[previous_section] ~= backgrounds[section]) and " "
                            or ""
                        previous_section = section

                        local icon = self.diagnostics.symbols[section]
                        local buffer_total = diagnostics_results[section][1] ~= 0 and diagnostics_results[section][1]
                            or "-"
                        local workspace_total = diagnostics_results[section][2]

                        table.insert(
                            output,
                            colors[section] .. padding .. icon .. buffer_total .. "/" .. workspace_total .. " "
                        )
                    end
                end

                return table.concat(output, " ")
            end

            return diagnostics
        end

        local color = {
            active_text = colors.vscPopupFront,
            incative_text = colors.vscCursorLight,
            inverted_text = colors.vscLeftDark,
            bg = colors.vscLeftDark,
            emphasized_bg = colors.vscLeftDark,
        }

        local function refresh_lualine_on_record()
            -- docs: https://www.reddit.com/r/neovim/comments/xy0tu1/comment/irfegvd/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
            vim.api.nvim_create_autocmd("RecordingEnter", {
                callback = function()
                    require("lualine").refresh({
                        place = { "statusline" },
                    })
                end,
            })

            vim.api.nvim_create_autocmd("RecordingLeave", {
                callback = function()
                    -- This is going to seem really weird!
                    -- Instead of just calling refresh we need to wait a moment because of the nature of
                    -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
                    -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
                    -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
                    -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
                    local timer = vim.loop.new_timer()
                    timer:start(
                        50,
                        0,
                        vim.schedule_wrap(function()
                            require("lualine").refresh({
                                place = { "statusline" },
                            })
                        end)
                    )
                end,
            })
        end
        refresh_lualine_on_record()

        local icon_filename = ""
        local encoding = ""
        local branch = ""

        local linemode = require("lualine.utils.mode")
        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = {
                    normal = {
                        a = { fg = color.inverted_text, bg = colors.vscBlue, gui = "bold" },
                        b = { fg = color.active_text, bg = color.bg },
                        c = { fg = color.active_text, bg = color.bg },
                    },
                    command = { a = { fg = color.inverted_text, bg = colors.vscMediumBlue, gui = "bold" } },
                    insert = { a = { fg = color.inverted_text, bg = colors.vscRed, gui = "bold" } },
                    visual = { a = { fg = color.inverted_text, bg = colors.vscDarkYellow, gui = "bold" } },
                    terminal = { a = { fg = color.inverted_text, bg = colors.vscRed, gui = "bold" } },
                    replace = { a = { fg = color.inverted_text, bg = colors.vscRed, gui = "bold" } },
                    inactive = {
                        a = { fg = color.incative_text, bg = color.bg, gui = "bold" },
                        b = { fg = color.incative_text, bg = color.bg },
                        c = { fg = color.incative_text, bg = color.bg },
                    },
                },
                component_separators = "",
                section_separators = {
                    left = "",
                    right = "",
                },
                disabled_filetypes = {},
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
            },
            sections = {
                lualine_a = {
                    {
                        function()
                            local m = linemode.get_mode()
                            if m == "NORMAL" then
                                return "N"
                            elseif m == "VISUAL" then
                                return "V"
                            elseif m == "SELECT" then
                                return "S"
                            elseif m == "INSERT" then
                                return "I"
                            elseif m == "REPLACE" then
                                return "R"
                            elseif m == "COMMAND" then
                                return "C"
                            elseif m == "EX" then
                                return "X"
                            elseif m == "TERMINAL" then
                                return "T"
                            else
                                return m
                            end
                        end,
                    },
                },
                lualine_b = {
                    {
                        function()
                            return ""
                        end,
                        color = { bg = colors.vscLeftMid, fg = color.bg },
                        padding = { left = -9 },
                    },
                    {
                        "filename",
                        path = 0,
                        timeout = 500,
                        fmt = function(value)
                            if should_ignore_filetype() then
                                return icon_filename
                            end
                            local session = require("auto-session.lib").current_session_name(true)
                            local devicons = require("nvim-web-devicons")
                            local icon = devicons.get_icon_by_filetype(vim.bo.filetype) or ""
                            if session == "" then
                                icon_filename = icon .. " " .. value
                                return icon_filename
                            end
                            icon_filename = icon .. " " .. session .. "\\" .. value
                            return icon_filename
                        end,
                        icon = { align = "right" },
                        padding = { left = 2, right = 1 },
                    },
                    {
                        diagnostics_component(),
                        sections = {
                            "error",
                            "warn",
                            "info",
                            "hint",
                        },
                        colors = {
                            error = { fg = colors.vscRed, bg = color.bg },
                            warn = { fg = colors.vscYellow, bg = color.bg },
                            info = { fg = colors.vscBlue, bg = color.bg },
                            hint = { fg = colors.vscDarkYellow, bg = color.bg },
                        },
                        symbols = {
                            error = require("../variables").diagnostics.ERROR .. " ",
                            warn = require("../variables").diagnostics.WARN .. " ",
                            info = require("../variables").diagnostics.INFO .. " ",
                            hint = require("../variables").diagnostics.HINT .. " ",
                        },
                    },
                },
                lualine_c = {},
                lualine_x = {
                    {
                        "macro-recording",
                        icon = { "", color = { fg = colors.vscDarkYellow } },
                        color = { fg = colors.vscSplitLight, bg = color.bg },
                        padding = { left = 1, right = 2 },
                        fmt = function()
                            local recording_register = vim.fn.reg_recording()
                            if recording_register == "" then
                                return ""
                            else
                                return "@" .. recording_register
                            end
                        end,
                    },
                    {
                        "encoding",
                        -- icon = { "", color = { fg = colors.vscPopupFront } },
                        color = { fg = colors.vscSplitLight, bg = color.bg },
                        timeout = 500,
                        padding = { left = 1, right = 2 },
                        fmt = function(value)
                            if should_ignore_filetype() then
                                return encoding
                            end
                            encoding = value
                            return value
                        end,
                        -- fmt = function(encoding)
                        --     local disable_capping = 0
                        --     local search = vim.fn.searchcount({ maxcount = disable_capping })
                        --     if search.total ~= 0 then
                        --         return search.current .. "/" .. search.total
                        --     end
                        --     return encoding
                        -- end,
                    },
                },
                lualine_y = {
                    -- {
                    --     'diff',
                    --     symbols = { added = ' ', modified = ' ', removed = ' ' },
                    --     diff_color = {
                    --         added = { fg = colors.vscBlue },
                    --         modified = { fg = colors.vscYellow },
                    --         removed = { fg = colors.vscRed },
                    --     },
                    --     icon = { '  ', align = 'right', color = { fg = colors.vscFront} },
                    -- },
                    {
                        "branch",
                        icon = { "󰘬", color = { fg = colors.vscRed } },
                        padding = { left = 1, right = 2 },
                        fmt = function(value)
                            if should_ignore_filetype() then
                                return branch
                            end
                            branch = value
                            return value
                        end,
                    },
                    -- {
                    --     function()
                    --         local msg = ''
                    --         local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                    --         local clients = vim.lsp.get_active_clients()
                    --         if next(clients) == nil then
                    --             return msg
                    --         end
                    --         for _, client in ipairs(clients) do
                    --             local filetypes = client.config.filetypes
                    --             if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    --                 return client.name
                    --             end
                    --         end
                    --         return msg
                    --     end,
                    --     color = { bg = color.vscRed, fg = color.vscRed },
                    --     icon = '',
                    -- }
                },
                lualine_z = {
                    "progress",
                },
            },
        })
    end,
}
