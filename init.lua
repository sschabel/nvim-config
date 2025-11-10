require("config.lazy")

vim.g.mapleader = " "  -- Sets the leader key to space
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'

--help files open in full window and are listed in buffer elements
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        vim.cmd("only")
        vim.bo.buflisted = true
    end
})

--disable netrrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.wo.relativenumber = true

--telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})

--harpoon
local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)

vim.keymap.set("n", "<C-,>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-.>", function() harpoon:list():next() end)

local treesitter = require('treesitter.treesitter_setup')
treesitter.setup()

-- setup JDTLS
-- Example mapping for running current test class
vim.keymap.set('n', '<leader>TC', function()
    require('jdtls').test_class()
end, { desc = 'Run current Java test class' })

-- Example mapping for running current test method
vim.keymap.set('n', '<leader>TM', function()
    require('jdtls').test_nearest_method()
end, { desc = 'Run nearest Java test method' })

