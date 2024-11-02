local function telescope_image_preview()
    local supported_images = { "svg", "png", "jpg", "jpeg", "gif", "webp", "avif" }
    local from_entry = require("telescope.from_entry")
    local Path = require("plenary.path")
    local conf = require("telescope.config").values
    local Previewers = require("telescope.previewers")

    local previewers = require("telescope.previewers")
    -- local image_api = require("image")

    local status, module = pcall(require, "image")

    if not status then
        -- Handle the error
        vim.notify("Error loading module: " .. module, "error")
    else
        -- Module loaded successfully
        vim.notify("Module loaded successfully", "error")
    end

    -- local is_image_preview = false
    -- local image = nil
    -- local last_file_path = ""
    --
    -- local is_supported_image = function(filepath)
    --     local split_path = vim.split(filepath:lower(), ".", { plain = true })
    --     local extension = split_path[#split_path]
    --     return vim.tbl_contains(supported_images, extension)
    -- end
    --
    -- local delete_image = function()
    --     if not image then
    --         return
    --     end
    --
    --     image:clear()
    --
    --     is_image_preview = false
    -- end
    --
    -- local create_image = function(filepath, winid, bufnr)
    --     image = image_api.hijack_buffer(filepath, winid, bufnr)
    --
    --     if not image then
    --         return
    --     end
    --
    --     vim.schedule(function()
    --         image:render()
    --     end)
    --
    --     is_image_preview = true
    -- end

    -- local function defaulter(f, default_opts)
    --     default_opts = default_opts or {}
    --     return {
    --         new = function(opts)
    --             if conf.preview == false and not opts.preview then
    --                 return false
    --             end
    --             opts.preview = type(opts.preview) ~= "table" and {} or opts.preview
    --             if type(conf.preview) == "table" then
    --                 for k, v in pairs(conf.preview) do
    --                     opts.preview[k] = vim.F.if_nil(opts.preview[k], v)
    --                 end
    --             end
    --             return f(opts)
    --         end,
    --         __call = function()
    --             local ok, err = pcall(f(default_opts))
    --             if not ok then
    --                 error(debug.traceback(err))
    --             end
    --         end,
    --     }
    -- end

    -- NOTE: Add teardown to cat previewer to clear image when close Telescope
    -- local file_previewer = defaulter(function(opts)
    --     opts = opts or {}
    --     local cwd = opts.cwd or vim.loop.cwd()
    --     return Previewers.new_buffer_previewer({
    --         title = "",
    --         dyn_title = function(_, entry)
    --             return Path:new(from_entry.path(entry, true)):normalize(cwd)
    --         end,
    --
    --         get_buffer_by_name = function(_, entry)
    --             return from_entry.path(entry, true)
    --         end,
    --
    --         define_preview = function(self, entry, _)
    --             local p = from_entry.path(entry, true)
    --             if p == nil or p == "" then
    --                 return
    --             end
    --
    --             conf.buffer_previewer_maker(p, self.state.bufnr, {
    --                 bufname = self.state.bufname,
    --                 winid = self.state.winid,
    --                 preview = opts.preview,
    --             })
    --         end,
    --
    --         teardown = function(_)
    --             if is_image_preview then
    --                 delete_image()
    --             end
    --         end,
    --     })
    -- end, {})

    -- local buffer_previewer_maker = function(filepath, bufnr, opts)
    --     -- NOTE: Clear image when preview other file
    --     if is_image_preview and last_file_path ~= filepath then
    --         delete_image()
    --     end
    --
    --     last_file_path = filepath
    --
    --     if is_supported_image(filepath) then
    --         create_image(filepath, opts.winid, bufnr)
    --     else
    --         previewers.buffer_previewer_maker(filepath, bufnr, opts)
    --     end
    -- end

    return {}
end

return {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    version = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "jonarrien/telescope-cmdline.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
    },
    keys = {
        {
            "<leader><leader>",
            function()
                require("telescope.builtin").find_files({
                    layout_strategy = "horizontal_merged",
                    find_command = { "rg", "--fixed-strings", "--files", "--hidden", "-g", "!.git" },
                })
            end,
            silent = true,
            desc = "telescope: [S]earch [F]iles (find/search files)",
        },
        -- { ":", "<cmd>Telescope cmdline<CR>", desc = "telescope: cmdline" },
        -- { mode = "v", ":", "<cmd>Telescope cmdline visual<CR>", desc = "telescope: cmdline" },
        -- {
        --     "/",
        --     function()
        --         require("telescope.builtin").current_buffer_fuzzy_find({
        --             previewer = false,
        --             sorting_strategy = "ascending",
        --             layout_config = {
        --                 prompt_position = "top",
        --                 height = 0.55,
        --                 width = 0.55,
        --             },
        --             layout_strategy = "horizontal_merged",
        --             attach_mappings = function(prompt_bufnr)
        --                 -- TODO: pass search results to setreg instead of the prompt
        --                 -- https://github.com/nvim-telescope/telescope.nvim/issues/2970
        --                 local actions = require("telescope.actions")
        --                 actions.select_default:replace(function()
        --                     local action_state = require("telescope.actions.state")
        --                     local prompt = action_state.get_current_line()
        --                     local entry = action_state.get_selected_entry()
        --                     if prompt then
        --                         vim.fn.setreg("/", prompt)
        --                     end
        --                     actions.close(prompt_bufnr)
        --                     vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.index })
        --                 end)
        --                 return true
        --             end,
        --         })
        --     end,
        --     desc = "telescope: [/] Fuzzy search in current buffer",
        -- },
        -- {
        --     "?",
        --     function()
        --         require("telescope.builtin").current_buffer_fuzzy_find({
        --             previewer = false,
        --             sorting_strategy = "ascending",
        --             layout_config = {
        --                 prompt_position = "top",
        --                 height = 0.55,
        --                 width = 0.55,
        --             },
        --             layout_strategy = "horizontal_merged",
        --             attach_mappings = function(prompt_bufnr)
        --                 -- TODO: pass search results to setreg instead of the prompt
        --                 -- https://github.com/nvim-telescope/telescope.nvim/issues/2970
        --                 local actions = require("telescope.actions")
        --                 actions.select_default:replace(function()
        --                     local action_state = require("telescope.actions.state")
        --                     local prompt = action_state.get_current_line()
        --                     local entry = action_state.get_selected_entry()
        --                     if prompt then
        --                         vim.fn.setreg("/", prompt)
        --                     end
        --                     actions.close(prompt_bufnr)
        --                     vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.index })
        --                 end)
        --                 return true
        --             end,
        --         })
        --     end,
        --     desc = "telescope: [?] Fuzzy search in current buffer",
        -- },
        {
            "<leader>sg",
            function()
                require("telescope.builtin").git_status({
                    layout_strategy = "horizontal_merged",
                    initial_mode = "normal",
                })
            end,
            desc = "telescope: [S]earch [G]it (find/search git)",
        },
        {
            "<leader>sb",
            function()
                require("telescope.builtin").git_branches({
                    sorting_strategy = "ascending",
                    initial_mode = "normal",
                    layout_strategy = "vertical_merged",
                })
            end,
            desc = "telescope: [S]earch [B]ranches (search git branches)",
        },
        {
            "<leader>sc",
            function()
                require("telescope.builtin").git_bcommits({
                    layout_strategy = "horizontal_merged",
                    initial_mode = "normal",
                })
            end,
            desc = "telescope: [S]earch branche [C]ommits (search git branche commits)",
        },
        {
            "<leader>ss",
            function()
                require("telescope.builtin").git_stash({
                    sorting_strategy = "ascending",
                    initial_mode = "normal",
                    layout_strategy = "vertical_merged",
                })
            end,
            desc = "telescope: [S]earch [B]ranches (search git branches)",
        },
        {
            "<leader>st",
            function()
                require("telescope.builtin").live_grep({ layout_strategy = "horizontal_merged" })
            end,
            desc = "telescope: [S]earch [T]ext (find/search text)",
        },
        {
            "<leader>sh",
            function()
                require("telescope.builtin").help_tags({ layout_strategy = "horizontal_merged" })
            end,
            desc = "telescope: [S]earch [H]elp (find/search help)",
        },
        {
            "<leader>sr",
            function()
                require("telescope.builtin").resume()
            end,
            desc = "telescope: [S]earch [R]esume",
        },
        {
            "<leader>?",
            function()
                require("telescope.builtin").keymaps({
                    sorting_strategy = "ascending",
                    layout_strategy = "center_merged",
                })
            end,
            noremap = true,
            silent = true,
            desc = "telescope: keymaps",
        },
    },
    config = function()
        local layout_strategies = require("telescope.pickers.layout_strategies")
        -- local image_preview = telescope_image_preview()

        layout_strategies.horizontal_merged = function(picker, max_columns, max_lines, layout_config)
            local layout = layout_strategies.horizontal(picker, max_columns, max_lines, layout_config)
            layout.prompt.title = ""
            layout.results.title = ""
            if layout.preview then
                layout.preview.title = ""
            end
            layout.results.height = layout.results.height + 1
            layout.prompt.borderchars = { "", "│", "─", "│", "", "", "┘", "└" }
            layout.results.borderchars = { "─", "│", "─", "│", "┌", "┐", "┤", "├" }
            if layout.preview then
                layout.preview.borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }
            end
            return layout
        end
        layout_strategies.vertical_merged = function(picker, max_columns, max_lines, layout_config)
            local layout = layout_strategies.vertical(picker, max_columns, max_lines, layout_config)
            layout.prompt.title = ""
            layout.results.title = ""
            if layout.preview then
                layout.preview.title = ""
            end
            -- layout.results.height = layout.results.height + 1 -- TODO: fix empty line for previewer
            layout.prompt.borderchars = { "─", "│", "─", "│", "┌", "┐", "┤", "├" }
            layout.results.borderchars = { " ", "│", "─", "│", "│", "│", "┘", "└" }
            if layout.preview then
                layout.preview.borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }
            end
            return layout
        end
        layout_strategies.center_merged = function(picker, max_columns, max_lines, layout_config)
            local layout = layout_strategies.center(picker, max_columns, max_lines, layout_config)
            layout.prompt.title = ""
            layout.results.title = ""
            layout.prompt.borderchars = { "─", "│", "", "│", "┌", "┐", "", "" }
            layout.results.borderchars = { "─", "│", "─", "│", "├", "┤", "┘", "└" }
            return layout
        end

        require("telescope").setup({
            defaults = {
                layout_strategy = "horizontal_merged",
                layout_config = {
                    horizontal = {
                        preview_width = 0.45,
                        preview_cutoff = 160,
                    },
                    vertical = {
                        preview_cutoff = 40,
                        height = 0.7,
                        width = 0.54,
                        prompt_position = "top",
                        mirror = true,
                    },
                    center = {
                        width = 0.54,
                    },
                },
                prompt_prefix = "   ",
                selection_caret = " ",
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--fixed-strings",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                    "-g",
                    "!.git",
                },
                mappings = {
                    i = { ["<c-q>"] = require("trouble.sources.telescope").open },
                    n = { ["<c-q>"] = require("trouble.sources.telescope").open },
                },
                -- file_previewer = image_preview.file_previewer,
                -- buffer_previewer_maker = image_preview.buffer_previewer_maker,
                -- open files in the first window that is an actual file.
                -- use the current window if no other window is available.
                -- copied from: https://github.com/LazyVim/LazyVim/blob/8024201e75b471eac5e399dcb6c8ec4f3f55e2a2/lua/lazyvim/plugins/editor.lua#L257-L269
                get_selection_window = function()
                    local wins = vim.api.nvim_list_wins()
                    table.insert(wins, 1, vim.api.nvim_get_current_win())
                    for _, win in ipairs(wins) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        if vim.bo[buf].buftype == "" then
                            return win
                        end
                    end
                    return 0
                end,
            },
            extensions = {
                -- file_browser = { hijack_netrw = true },
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown({
                        sorting_strategy = "ascending",
                        initial_mode = "normal",
                        layout_strategy = "center_merged",
                        layout_config = {
                            height = 0.4,
                            width = 0.54,
                        },
                    }),
                },
                -- cmdline = {
                --     picker = {
                --         sorting_strategy = "ascending",
                --         layout_config = {
                --             prompt_position = "top",
                --             width = 120,
                --             height = 25,
                --         },
                --     },
                --     mappings = {
                --         complete = "<Tab>",
                --         run_selection = "<C-CR>",
                --         run_input = "<CR>",
                --     },
                -- },
            },
        })
        -- pcall(require("telescope").load_extension, "cmdline")
        pcall(require("telescope").load_extension, "ui-select")
        pcall(require("telescope").load_extension, "fzf")
    end,
}
