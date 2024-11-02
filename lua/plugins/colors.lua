return {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    init = function()
        vim.o.termguicolors = true
        vim.o.background = "dark"
        vim.opt.cursorline = true
    end,
    config = function()
        local colors = require("vscode.colors").get_colors()
        require("vscode").setup({
            transparent = true,
            disable_nvimtree_bg = true,
            color_overrides = {
                vscPopupHighlightBlue = colors.vscTabOutside,
                vscSplitDark = colors.vscTabOther,
            },
            group_overrides = {
                StatusLine = { bg = colors.vscLeftDark },
                LineNr = { fg = colors.vscDimHighlight },
                CursorLineNr = { fg = "#ffffff" },
                Visual = { bg = "#173049" },
                Folded = { bg = "NONE" },
                NormalFloat = { bg = "NONE" },
                MoreMsg = { fg = colors.vscFront, bg = "NONE" }, -- confirm message
                Pmenu = { fg = "#bbbbbb", bg = "NONE" },

                CmpDocumentationNormal = { fg = colors.vscContextCurrent, bg = "NONE" },
                CmpDocumentationBorder = { link = "FloatBorder" },
                CmpCompletionNormal = { fg = colors.vscContextCurrent, bg = "NONE" },
                CmpCompletionBorder = { link = "FloatBorder" },

                DiagnosticError = { fg = colors.vscRed },
                DiagnosticWarn = { fg = colors.vscYellow },
                DiagnosticInfo = { fg = colors.vscMediumBlue },
                DiagnosticHint = { fg = colors.vscDarkYellow },
                DiagnosticUnderlineError = { link = "DiagnosticError" },
                DiagnosticUnderlineWarn = { link = "DiagnosticWarn" },
                DiagnosticUnderlineInfo = { link = "DiagnosticInfo" },
                DiagnosticUnderlineHint = { link = "DiagnosticHint" },

                IblIndent = { fg = "#2A2A2A" },
                IblScope = { fg = colors.vscLeftMid },

                NvimTreeOpenedFolderName = { bg = "NONE", fg = "#ffffff", bold = true },

                NeoTreeFileIcon = { fg = colors.vscFront },
                NeoTreeDirectoryName = { fg = "#ffffff" },
                NeoTreeIndentMarker = { link = "IblIndent" },
                NeoTreeDotfile = { fg = colors.vscLineNumber },
                NeoTreeFloatBorder = { link = "FloatBorder" },

                GitSignsAdd = { fg = colors.vscMediumBlue, bg = "NONE" },
                GitSignsChange = { fg = colors.vscDarkYellow, bg = "NONE" },
                GitSignsDelete = { fg = colors.vscRed, bg = "NONE" },

                NeotestAdapterName = { fg = colors.vscFront, bold = true },
                NeotestPassed = { fg = colors.vscGitAdded },
                NeotestFocused = { fg = "#ffffff" },
                NeotestSkipped = { fg = colors.vscRed },
                NeotestDir = { fg = colors.vscFront },
                NeotestExpandMarker = { link = "IblIndent" },
                NeotestIndent = { link = "IblIndent" },
                NeotestFile = { fg = colors.vscFront },
                NeotestTest = { fg = colors.vscFront },
                NeotestUnknown = { fg = "#1354BF" },

                DapStopped = { fg = colors.vscDarkYellow },
                DapBreakpoint = { fg = colors.vscRed },

                FloatBorder = { fg = colors.vscTabOther },
                HarpoonBorder = { link = "FloatBorder" },

                TelescopeBorder = { link = "FloatBorder" },
                TelescopePromptBorder = { link = "FloatBorder" },
                TelescopeResultsBorder = { link = "FloatBorder" },
                TelescopePreviewBorder = { link = "FloatBorder" },
                TelescopeResultsSpecialComment = { fg = colors.vscLineNumber },

                NotifyERRORBorder = { link = "FloatBorder" },
                NotifyWARNBorder = { link = "FloatBorder" },
                NotifyINFOBorder = { link = "FloatBorder" },
                NotifyDEBUGBorder = { link = "FloatBorder" },
                NotifyTRACEBorder = { link = "FloatBorder" },

                illuminatedWord = { bg = "#2f3438" },
                illuminatedCurWord = { link = "illuminatedWord" },
                IlluminatedWordText = { link = "illuminatedWord" },
                IlluminatedWordRead = { link = "illuminatedWord" },
                IlluminatedWordWrite = { link = "illuminatedWord" },
                Search = { link = "illuminatedWord" },
                CurSearch = { link = "illuminatedWord" },

                TroublePreview = { link = "Visual" },
                TroubleIconDirectory = { link = "NeoTreeDirectoryIcon" },
                TroubleDirectory = { link = "NeoTreeDirectoryName" },
                TroubleTelescopeFileName = { link = "NeoTreeDirectoryName" },
                TroubleIndent = { link = "IblIndent" },
                TroubleCount = { link = "TroublePos" },

                NoiceCmdlineIconSearch = { link = "Normal" },
                NoiceCmdlineIconFilter = { fg = colors.vscRed },
                NoiceCmdlinePopupBorder = { link = "FloatBorder" },
                NoiceCmdlinePopupBorderCalculator = { link = "FloatBorder" },
                NoiceCmdlinePopupBorderCmdline = { link = "FloatBorder" },
                NoiceCmdlinePopupBorderFilter = { link = "FloatBorder" },
                NoiceCmdlinePopupBorderHelp = { link = "FloatBorder" },
                NoiceCmdlinePopupBorderIncRename = { link = "FloatBorder" },
                NoiceCmdlinePopupBorderInput = { link = "FloatBorder" },
                NoiceCmdlinePopupBorderLua = { link = "FloatBorder" },
                NoiceCmdlinePopupBorderSearch = { link = "FloatBorder" },
            },
        })
        require("vscode").load()
    end,
}
