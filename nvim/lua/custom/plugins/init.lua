--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

vim.g.material_style = 'deep ocean'

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- for obisidna.nvim
vim.o.conceallevel = 2

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', 'gd', ':ObsidianFollowLink<CR>', { noremap = true, silent = true })
  end,
})

-- Correctly mapping in Normal mode to use 'pu' and 'pu!' commands
vim.api.nvim_set_keymap('n', 'p', ':pu<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'P', ':pu!<CR>', { noremap = true, silent = true })

-- keep cursor at the same place when joining lines, moving, and searching
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('x', '<leader>p', [["_dP]])

vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.o.clipboard = 'unnamedplus'

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

vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

function insert_foldable_region()
  local region_name = vim.fn.input 'Region Description: '
  local indent = string.rep(' ', vim.fn.indent '.')
  local start_marker = indent .. '/* {{{ Region: ' .. region_name .. ' */'
  local end_marker = indent .. '/* End Region:  ' .. region_name .. ' }}} */'
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, line_num, line_num, false, { start_marker, '', end_marker })
  vim.api.nvim_win_set_cursor(0, { line_num + 1, 0 })
end

-- Key mapping
vim.api.nvim_set_keymap('n', '<Leader>fr', '', { noremap = true, silent = true, callback = insert_foldable_region })

-- Optionally, set 'foldmethod' to 'marker' for the current window
vim.wo.foldmethod = 'marker'

return {
  {
    'ggandor/flit.nvim',
    config = function()
      require('flit').setup {
        keys = { f = 'f', F = 'F', t = 't', T = 'T' },
        -- A string like "nv", "nvo", "o", etc.
        labeled_modes = 'v',
        multiline = true,
        -- Like `leap`s similar argument (call-specific overrides).
        -- E.g.: opts = { equivalence_classes = {} }
        opts = {},
      }
    end,
  },
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = 'markdown',
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      conceallevel = 1,
      workspaces = {
        {
          name = 'personal',
          path = '~/Documents/notes',
        },
      },
    },
  },
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
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
      -- vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    'saecki/crates.nvim',
    tag = 'stable',
    config = function()
      local crates = require 'crates'

      local function show_documentation()
        local filetype = vim.bo.filetype
        if vim.tbl_contains({ 'vim', 'help' }, filetype) then
          vim.cmd('h ' .. vim.fn.expand '<cword>')
        elseif vim.tbl_contains({ 'man' }, filetype) then
          vim.cmd('Man ' .. vim.fn.expand '<cword>')
        elseif vim.fn.expand 'u%:t' == 'Cargo.toml' and require('crates').popup_available() then
          require('crates').show_popup()
        else
          vim.lsp.buf.hover()
        end
      end

      vim.keymap.set('n', '<leader>ct', crates.toggle, opts)
      vim.keymap.set('n', '<leader>cr', crates.reload, opts)

      vim.keymap.set('n', '<leader>cv', crates.show_versions_popup, opts)
      vim.keymap.set('n', '<leader>cf', crates.show_features_popup, opts)
      vim.keymap.set('n', '<leader>cd', crates.show_dependencies_popup, opts)

      vim.keymap.set('n', '<leader>cu', crates.update_crate, opts)
      vim.keymap.set('v', '<leader>cu', crates.update_crates, opts)
      vim.keymap.set('n', '<leader>ca', crates.update_all_crates, opts)
      vim.keymap.set('n', '<leader>cU', crates.upgrade_crate, opts)
      vim.keymap.set('v', '<leader>cU', crates.upgrade_crates, opts)
      vim.keymap.set('n', '<leader>cA', crates.upgrade_all_crates, opts)

      vim.keymap.set('n', '<leader>cx', crates.expand_plain_crate_to_inline_table, opts)
      vim.keymap.set('n', '<leader>cX', crates.extract_crate_into_table, opts)

      vim.keymap.set('n', '<leader>cH', crates.open_homepage, opts)
      vim.keymap.set('n', '<leader>cR', crates.open_repository, opts)
      vim.keymap.set('n', '<leader>cD', show_documentation, { silent = true })
      vim.keymap.set('n', '<leader>cC', crates.open_crates_io, opts)

      vim.keymap.set('n', 'K', show_documentation, { silent = true })
      require('crates').setup {
        null_ls = {
          enabled = true,
          name = 'crates.nvim',
        },
        src = {
          coq = {
            enabled = true,
            name = 'crates.nvim',
          },
        },
      }
    end,
  },
  {
    'simrat39/rust-tools.nvim',

    config = function()
      local rt = require 'rust-tools'

      rt.setup {
        server = {
          on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set('n', '<Leader>la', rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
      }
    end,
  },
}
