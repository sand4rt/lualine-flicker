return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    branch = "fix/flickering",
    config = function()
        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = {},
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
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {
                    "progress",
                },
            },
        })
    end,
}
