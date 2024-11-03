local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_set_keymap("n", "<leader>l", "<cmd>Lazy<CR>", { noremap = true })
require("lazy").setup("plugins", {
    change_detection = {
        notify = false,
    },
    ui = {
        size = { width = 0.64, height = 0.7 },
        border = "single",
    },
})

