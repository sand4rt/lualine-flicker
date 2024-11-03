return {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    version = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        {
            "<leader><leader>",
            function()
                require("telescope.builtin").find_files({
                    find_command = { "rg", "--fixed-strings", "--files", "--hidden", "-g", "!.git" },
                })
            end,
            silent = true,
            desc = "telescope: [S]earch [F]iles (find/search files)",
        },
    },
    config = function()
        require("telescope").setup({
            defaults = {
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
            },
        })
    end,
}

