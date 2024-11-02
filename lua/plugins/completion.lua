return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "saadparwaiz1/cmp_luasnip",
            {
                "L3MON4D3/LuaSnip",
                dependencies = {
                    "rafamadriz/friendly-snippets",
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load()
                    end,
                },
            },
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})
            cmp.setup({
                experimental = {
                    ghost_text = { hl_group = "CmpCompletionNormal" },
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },
                window = {
                    completion = cmp.config.window.bordered({
                        border = "single",
                        winhighlight = "FloatBorder:CmpCompletionBorder",
                    }),
                    documentation = cmp.config.window.bordered({
                        border = "single",
                        winhighlight = "FloatBorder:CmpCompletionBorder",
                    }),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete({}),
                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "copilot", group_index = 2, priority = 100 },
                    { name = "nvim_lsp", group_index = 2, priority = 90 },
                    { name = "luasnip", group_index = 2, priority = 80 },
                    { name = "path" },
                }),
            })
            cmp.setup.filetype("sql", {
                sources = cmp.config.sources({
                    { name = "vim-dadbod-completion" },
                    { name = "buffer" },
                }),
            })
            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
                }, {
                    { name = "buffer" },
                }),
            })
        end,
    },
}
