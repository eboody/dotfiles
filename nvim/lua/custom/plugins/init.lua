-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

vim.g.material_style = 'deep ocean'

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Saving with <C-s>
map('n', '<C-s>', ':w<CR>', opts)

-- Navigation between buffers
map('n', '<S-l>', ':BufferLineCycleNext<CR>', opts)
map('n', '<S-h>', ':BufferLineCyclePrev<CR>', opts)

-- Scrolling with centering
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)

-- Moving lines in visual mode
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Telescope and Trouble
map('n', '<leader><leader>', ':Telescope buffers<CR>', opts)
map('n', '<leader>t', '<cmd>TroubleToggle<CR>', opts)
map('n', '<leader>o', '<cmd>SymbolsOutline<CR>', opts)

-- Tmux navigation
map('n', '<C-h>', '<cmd> TmuxNavigateLeft<CR>', opts)
map('n', '<C-l>', '<cmd> TmuxNavigateRight<CR>', opts)
map('n', '<C-j>', '<cmd> TmuxNavigateDown<CR>', opts)
map('n', '<C-k>', '<cmd> TmuxNavigateUp<CR>', opts)

-- Meta key window navigation
map('n', '<m-h>', '<C-w>h', opts)
map('n', '<m-j>', '<C-w>j', opts)
map('n', '<m-k>', '<C-w>k', opts)
map('n', '<m-l>', '<C-w>l', opts)
map('n', '<m-tab>', '<c-6>', opts)

vim.api.nvim_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('neo-tree').setup {}
    end,
  },
  {
    'marko-cerovac/material.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- Load the colorscheme here
      vim.cmd 'colorscheme material'

      -- You can configure highlights by doing something like
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
