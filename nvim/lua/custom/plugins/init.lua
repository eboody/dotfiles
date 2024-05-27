-- vim.cmd [[
--   autocmd FileType rust highlight macro ctermfg=8 guifg=#555555
-- ]]
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'rust',
--   callback = function()
--     vim.api.nvim_set_hl(0, 'macro', { fg = '#555555' })
--   end,
-- })
--
-- auto close neotree when I close the editor buffer

-- Use :Quit instead of :q to quit Neovim
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   callback = function()
--     vim.cmd 'Neotree close'
--   end,
-- })
--

local function find_nearest_error_file()
  local current_file = vim.fn.expand '%:p'
  local current_dir = vim.fn.fnamemodify(current_file, ':h')

  while current_dir ~= '' and current_dir ~= '/' do
    local potential_error_file = current_dir .. '/error.rs'
    if vim.fn.filereadable(potential_error_file) == 1 then
      vim.cmd('edit ' .. potential_error_file)
      return
    end
    current_dir = vim.fn.fnamemodify(current_dir, ':h')
  end
  print 'No nearest error.rs file found'
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function()
    vim.keymap.set('n', '<space>E', find_nearest_error_file, { buffer = true })
  end,
})

function CycleLineEndings(endings)
  local line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local col = cursor_pos[2] + 1

  local current_ending = ''
  for _, ending in ipairs(endings) do
    if line:sub(-#ending) == ending then
      current_ending = ending
      break
    end
  end

  local next_index = 1
  for i, ending in ipairs(endings) do
    if ending == current_ending then
      next_index = i % #endings + 1
      break
    end
  end

  local new_line = line:sub(1, #line - #current_ending) .. endings[next_index]
  vim.api.nvim_set_current_line(new_line)

  local new_col = #new_line < col and #new_line or col
  vim.api.nvim_win_set_cursor(0, { cursor_pos[1], new_col - 1 })
end

vim.api.nvim_set_keymap('n', '<M-;>', ":lua CycleLineEndings({'',';'})<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-C-;>', ":lua CycleLineEndings({'.await;','.await?;', ';'})<CR>", { noremap = true, silent = true })
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
    vim.api.nvim_buf_set_keymap(0, 'n', 'gd', ':ObsidianFollowLink<CR>', opts)
  end,
})

-- Correctly mapping in Normal mode to use 'pu' and 'pu!' commands
vim.api.nvim_set_keymap('n', 'p', ':pu<CR>', opts)
vim.api.nvim_set_keymap('n', 'P', ':pu!<CR>', opts)

-- keep cursor at the same place when joining lines, moving, and searching
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('x', '<leader>p', [["_dP]])
vim.keymap.set('n', '<leader>ll', ':LspRestart<CR>')

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

vim.api.nvim_set_keymap('i', 'jj', '<Esc>', opts)

vim.api.nvim_set_keymap('n', '<leader>e', "<cmd>lua require('oil').toggle_float(vim.fn.expand('%:p:h'))<CR>", { noremap = true, silent = true })

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
vim.opt.termguicolors = true

-- Set the background color for the entire editor

vim.api.nvim_set_keymap('n', '<leader>e', ":lua require('oil').toggle_float(vim.fn.expand('%:p:h'))<CR>", { noremap = true, silent = true })

return {
  -- {
  --   'nvim-neo-tree/neo-tree.nvim',
  --   version = '*',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  --     'MunifTanjim/nui.nvim',
  --   },
  --   config = function()
  --     require('neo-tree').setup {}
  --   end,
  -- },
  { 'echasnovski/mini.nvim' },
  {
    'stevearc/oil.nvim',
    opts = {},
    config = function()
      require('oil').setup {
        use_default_keymaps = false,
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-\\>'] = 'actions.select_split',
          ['<C-enter>'] = 'actions.select_vsplit', -- this is used to navigate left
          ['<C-t>'] = 'actions.select_tab',
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = 'actions.close',
          ['<C-r>'] = 'actions.refresh',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['~'] = 'actions.tcd',
          ['gs'] = 'actions.change_sort',
          ['gx'] = 'actions.open_external',
          ['g.'] = 'actions.toggle_hidden',
        },
        git = {
          -- Return true to automatically git add/mv/rm files
          add = function(path)
            return true
          end,
          mv = function(src_path, dest_path)
            return true
          end,
          rm = function(path)
            return true
          end,
        },
        view_options = {
          show_hidden = true,
        },
      }
    end,
  },
  -- {
  --   'brenoprata10/nvim-highlight-colors',
  --   config = function()
  --     require('nvim-highlight-colors').setup {}
  --   end,
  -- },
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
          path = '~/documents/notes',
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
    'sainnhe/sonokai',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.g.sonokai_enable_italic = true
      vim.g.sonokai_disable_terminal_colors = false
      vim.g.sonokai_colors_override = {
        bg0 = { '#0e0e0e', '235' },
        bg1 = { '#1e1e1e', '236' },
        bg2 = { '#1e1e1e', '236' },
        bg3 = { '#2e2e2e', '237' },
        bg4 = { '#2e2e2e', '237' },
      }
      vim.cmd 'colorscheme sonokai'
    end,
  },
  -- {
  --   'marko-cerovac/material.nvim',
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- Load the colorscheme here
  --     vim.cmd 'colorscheme material'
  --
  --     vim.api.nvim_set_hl(0, 'Normal', { bg = '#0e0e0e' })
  --     -- You can configure highlights by doing something like
  --     -- vim.cmd.hi 'Comment gui=none'
  --   end,
  -- },
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
