return {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    cmd = "Neotree",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    init = function()
        vim.g.loaded_netrw = 0
        vim.g.loaded_netrwPlugin = 0
    end,
    keys = {
        { "<leader>e", "<cmd>:Neotree toggle<CR>", desc = "nvim-tree: File [E]xplorer (file explorer)" },
    },
    opts = {
        event_handlers = {
            {
                event = "file_opened",
                handler = function()
                    require("neo-tree.command").execute({ action = "close" })
                end,
            },
        },
        hide_root_node = true,
        auto_clean_after_session_restore = true, -- fixes auto resore issue: https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1365
        close_if_last_window = true,
        popup_border_style = "single",
        use_popups_for_input = false,
        enable_git_status = true,
        enable_diagnostics = true,
        log_level = "error",
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
        sort_case_insensitive = false, -- used when sorting files and directories in the tree
        sort_function = nil, -- use a custom function for sorting files and directories in the tree
        default_component_configs = {
            container = {
                enable_character_fade = true,
            },
            indent = {
                indent_size = 2,
                level = 0,
                padding = 0, -- extra padding on left hand side
                with_markers = true,
                with_expanders = false, -- if nil and file nesting is enabled, will enable expanders
                expander_highlight = "NeoTreeExpander",
            },
            icon = {
                folder_closed = require("../variables").folders.folder_closed,
                folder_open = require("../variables").folders.folder_open,
                folder_empty = require("../variables").folders.folder_empty,
                -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                -- then these will never be used.
                default = require("../variables").folders.default,
                highlight = "NeoTreeFileIcon",
            },
            modified = {
                symbol = " ",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },
            git_status = {
                symbols = {
                    -- Change type
                    added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                    modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
                    deleted = "✗", -- this can only be used in the git_status source
                    renamed = "➜", -- this can only be used in the git_status source
                    -- Status type
                    untracked = "󰄱",
                    ignored = "",
                    unstaged = "󰄱",
                    staged = "",
                    conflict = "",
                },
            },
            -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
            file_size = {
                enabled = true,
                required_width = 64, -- min width of window required to show this column
            },
            type = {
                enabled = true,
                required_width = 122, -- min width of window required to show this column
            },
            last_modified = {
                enabled = true,
                required_width = 88, -- min width of window required to show this column
            },
            created = {
                enabled = true,
                required_width = 110, -- min width of window required to show this column
            },
            symlink_target = {
                enabled = false,
            },
        },
        window = {
            position = "left",
            width = 46,
            mapping_options = {
                noremap = true,
                nowait = true,
            },
            mappings = {
                ["<space>"] = {
                    "toggle_node",
                    nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
                },
                ["<2-LeftMouse>"] = "open",
                ["<cr>"] = "open",
                ["q"] = "cancel", -- close preview or floating neo-tree window
                ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = false } },
                -- Read `# Preview Mode` for more information
                ["l"] = "focus_preview",
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                -- ["S"] = "split_with_window_picker",
                -- ["s"] = "vsplit_with_window_picker",
                ["t"] = "open_tabnew",
                -- ["<cr>"] = "open_drop",
                -- ["t"] = "open_tab_drop",
                ["w"] = "open_with_window_picker",
                --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
                ["C"] = "close_node",
                -- ['C'] = 'close_all_subnodes',
                ["z"] = "close_all_nodes",
                --["Z"] = "expand_all_nodes",
                ["a"] = {
                    "add",
                    -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
                    -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                    config = {
                        show_path = "none", -- "none", "relative", "absolute"
                    },
                },
                ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
                ["d"] = "delete",
                ["r"] = { "rename", config = { title = "" } },
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
                -- ["c"] = {
                --  "copy",
                --  config = {
                --    show_path = "none" -- "none", "relative", "absolute"
                --  }
                --}
                ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
                ["<esc>"] = "close_window",
                ["R"] = "refresh",
                ["?"] = { "show_help", config = { title = "" } },
                ["<"] = "prev_source",
                [">"] = "next_source",
                ["i"] = "show_file_details",
            },
        },
        filesystem = {
            filtered_items = {
                visible = true, -- when true, they will just be displayed differently than normal items
                hide_dotfiles = false,
                hide_gitignored = true,
                hide_hidden = true, -- only works on Windows for hidden files/directories
                hide_by_name = {
                    "node_modules",
                    ".git",
                },
                hide_by_pattern = { -- uses glob style patterns
                    --"*.meta",
                    --"*/src/*/tsconfig.json",
                },
                always_show = { -- remains visible even if other settings would normally hide it
                    --".gitignored",
                },
                never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                    ".DS_Store",
                    "thumbs.db",
                },
                never_show_by_pattern = { -- uses glob style patterns
                    --".null-ls_*",
                },
            },
            follow_current_file = {
                enabled = true, -- This will find and focus the file in the active buffer every time
                --               -- the current file is changed while the tree is open.
                leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
            },
            group_empty_dirs = true, -- when true, empty folders will be grouped together
            hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
            -- in whatever position is specified in window.position
            -- "open_current",  -- netrw disabled, opening a directory opens within the
            -- window like netrw would, regardless of window.position
            -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
            use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
            -- instead of relying on nvim autocmd events.
            window = {
                mappings = {
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                    ["H"] = "toggle_hidden",
                    ["/"] = { "fuzzy_finder", config = { title = "" } },
                    ["D"] = "fuzzy_finder_directory",
                    ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
                    -- ["D"] = "fuzzy_sorter_directory",
                    ["f"] = "filter_on_submit",
                    ["<c-x>"] = "clear_filter",
                    ["[g"] = "prev_git_modified",
                    ["]g"] = "next_git_modified",
                    ["o"] = { "show_help", nowait = false, config = { title = "", prefix_key = "o" } },
                    ["oc"] = { "order_by_created", nowait = false },
                    ["od"] = { "order_by_diagnostics", nowait = false },
                    ["og"] = { "order_by_git_status", nowait = false },
                    ["om"] = { "order_by_modified", nowait = false },
                    ["on"] = { "order_by_name", nowait = false },
                    ["os"] = { "order_by_size", nowait = false },
                    ["ot"] = { "order_by_type", nowait = false },
                },
                fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
                    ["<down>"] = "move_cursor_down",
                    ["<C-n>"] = "move_cursor_down",
                    ["<up>"] = "move_cursor_up",
                    ["<C-p>"] = "move_cursor_up",
                },
            },

            commands = {}, -- Add a custom command or override a global one using the same function name
        },
        buffers = {
            follow_current_file = {
                enabled = true, -- This will find and focus the file in the active buffer every time
                --              -- the current file is changed while the tree is open.
                leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
            },
            group_empty_dirs = true, -- when true, empty folders will be grouped together
            show_unloaded = true,
            window = {
                mappings = {
                    ["bd"] = "buffer_delete",
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                    ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
                    ["oc"] = { "order_by_created", nowait = false },
                    ["od"] = { "order_by_diagnostics", nowait = false },
                    ["om"] = { "order_by_modified", nowait = false },
                    ["on"] = { "order_by_name", nowait = false },
                    ["os"] = { "order_by_size", nowait = false },
                    ["ot"] = { "order_by_type", nowait = false },
                },
            },
        },
        git_status = {
            window = {
                position = "float",
                mappings = {
                    ["A"] = "git_add_all",
                    ["gu"] = "git_unstage_file",
                    ["ga"] = "git_add_file",
                    ["gr"] = "git_revert_file",
                    ["gc"] = "git_commit",
                    ["gp"] = "git_push",
                    ["gg"] = "git_commit_and_push",
                    ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
                    ["oc"] = { "order_by_created", nowait = false },
                    ["od"] = { "order_by_diagnostics", nowait = false },
                    ["om"] = { "order_by_modified", nowait = false },
                    ["on"] = { "order_by_name", nowait = false },
                    ["os"] = { "order_by_size", nowait = false },
                    ["ot"] = { "order_by_type", nowait = false },
                },
            },
        },
    },
}
