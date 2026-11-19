-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

-- NOTE: To install a plugin you just need to add the URL to the repository.
-- But as soon as you need to add more information, like the git branch or
-- commit, use the "plugin spec" form. See :help vim.pack

vim.pack.add({
  'https://github.com/nvim-tree/nvim-web-devicons', -- nerd font icons
  'https://github.com/mhinz/vim-startify', -- startup screen
  'https://github.com/rebelot/kanagawa.nvim', -- color theme
  { src = 'https://github.com/folke/which-key.nvim', version = '3aab2147e74890957785941f0c1ad87d0a44c15a' }, -- popup hint for keymaps
  { src = 'https://github.com/nvim-mini/mini.nvim', version = 'v0.18.0' }, -- collections of small plugins
  { src = 'https://github.com/neovim/nvim-lspconfig', version = 'v2.12.0' }, -- LSP config
  { src = 'https://github.com/mason-org/mason.nvim', version = 'v2.3.0' }, -- LSP installer
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim', version = 'v2.3.0' }, -- sync mason LSP & nvim-lspconfig
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' }, -- treesitter
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1' }, -- auto-completion
  'https://github.com/rafamadriz/friendly-snippets', -- vscode-like snippets
  { src = 'https://github.com/lewis6991/gitsigns.nvim', version = 'v2.1.0' }, -- Git info & inline status
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range('3') }, -- sidebar directory tree
  { src = 'https://github.com/MunifTanjim/nui.nvim', version = '0.4.0' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/tpope/vim-sleuth', -- auto indentation
  'https://github.com/christoomey/vim-tmux-navigator', -- moving between nvim and tmux pane with Ctrl+hjkl
})

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

vim.cmd.colorscheme('kanagawa')

-- See :help startify
local v = vim.version()
local nvim_version_str = string.format("--- Neovim v%d.%d.%d ---", v.major, v.minor, v.patch)
vim.g.startify_custom_footer = vim.fn['startify#pad']({ nvim_version_str })
vim.g.startify_change_to_dir = 0

-- See :help MiniComment.config
require('mini.comment').setup({})  -- 'gc' & 'gcc' to comments

-- -- See :help MiniSurround.config
require("mini.surround").setup({
  mappings = {
    add = "gsa",        -- Add surrounding in Normal and Visual modes
    delete = "gsd",     -- Delete surrounding
    find = "gsf",       -- Find right surrounding
    find_left = "gsF",  -- Find left surrounding
    highlight = "gsh",  -- Highlight surrounding
    replace = "gsr",    -- Replace surrounding
    update_n_lines = "gsn",
  },
})

-- See :help MiniNotify.config
require('mini.notify').setup({
  lsp_progress = {enable = false},
})

-- See :help MiniPairs.config
-- use vim.pack.add({'https://github.com/windwp/nvim-autopairs'}) later if not satisfied
require('mini.pairs').setup({})

-- See :help MiniPick.config
local win_config = function()
  local height = math.floor(0.75 * vim.o.lines)
  local width = math.floor(0.5 * vim.o.columns)
  return {
    border = 'rounded',
    anchor = 'NW', height = height, width = width,
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
  }
end

local mini_pick = require('mini.pick')
mini_pick.setup({
  window = { config = win_config },
})
local custom_rg_command = function(command, name)
  local show_with_icons = function(buf_id, items, query)
    return mini_pick.default_show(buf_id, items, query, { show_icons = true })
  end
  local source = { name = name, show = show_with_icons }
  return mini_pick.builtin.cli({ command = command }, { source = source })
end
mini_pick.registry.files_repo = function()
  return custom_rg_command({'rg', '--files', '--color=never', '--hidden'}, 'Repo files')
end
mini_pick.registry.files_hidden = function()
  return custom_rg_command({'rg', '--files', '--color=never', '--hidden', '--no-ignore'}, 'Hidden files')
end
mini_pick.registry.current_word = function()
  return mini_pick.builtin.grep_live({ query = vim.fn.expand('<cword>') })
end

-- See available pickers
-- ':help MiniPick.builtin' and ':help MiniExtra.pickers'
-- vim.keymap.set('n', '<leader>sf', '<cmd>Pick files<cr>', {desc = '[S]earch [F]iles'})  -- don't like default behavior
vim.keymap.set('n', '<leader>sf', '<cmd>Pick files_repo<cr>', {desc = '[S]earch [F]iles'})
vim.keymap.set('n', '<leader>s.', '<cmd>Pick files_hidden<cr>', {desc = '[S]earch [.]All Files'})
vim.keymap.set('n', '<leader>sg', '<cmd>Pick grep_live<cr>', {desc = '[S]earch by [G]rep'})
vim.keymap.set('n', '<leader>sw', '<cmd>Pick current_word<cr>', {desc = '[S]earch current [W]ord'})
vim.keymap.set('n', '<leader>sd', '<cmd>Pick diagnostic<cr>', {desc = '[S]earch [D]iagnostics'})
vim.keymap.set('n', '<leader>sr', '<cmd>Pick resume<cr>', {desc = '[S]earch [R]esume'})
-- vim.keymap.set('n', '<leader>?', '<cmd>Pick oldfiles<cr>', {desc = 'Search file history'})
-- vim.keymap.set('n', '<leader><space>', '<cmd>Pick buffers<cr>', {desc = 'Search open files'})
-- vim.keymap.set('n', '<leader>fs', '<cmd>Pick buf_lines<cr>', {desc = 'Buffer local search'})

-- See :help MiniExtra
require('mini.extra').setup({})

-- See :help MiniStatusline.config
require('mini.statusline').setup({})

-- See :help MiniSnippets.config
require('mini.snippets').setup({})

-- See :help neo-tree
require('neo-tree').setup({
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_ignored = false,
    },
  },
})
vim.keymap.set('n', '\\', ':Neotree filesystem toggle right<cr>', {desc = 'Show directory', silent = true})

-- See :help which-key.nvim-which-key-setup
require('which-key').setup({
  preset = 'classic',
  icons = {
    mappings = vim.g.have_nerd_font,
    keys = {
      Space = 'Space',
      Esc = 'Esc',
      BS = 'Backspace',
      C = 'Ctrl-',
    },
  },
})

-- require('which-key').add({
--   {'<leader>f', group = 'Fuzzy Find'},
--   {'<leader>b', group = 'Buffer'},
-- })

-- See :help gitsigns
-- '[c' and ']c' for prev / next git change
require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
})

-- See :help blink-cmp-config
local blink = require('blink.cmp')
local blink_capabilities = blink.get_lsp_capabilities()
blink.setup({
  keymap = { preset = 'super-tab' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    -- `<C-space>` to show the documentation or set auto_show = true
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },
  cmdline = { enabled = false },
  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },
  -- See :h blink-cmp-config-fuzzy for more information
  fuzzy = {
    implementation = 'prefer_rust',
    prebuilt_binaries = { force_version = 'v1.*' },
  },
  signature = { enabled = true },
})

-- Treesitter setup
-- Try to update all parsers after a plugin update
vim.api.nvim_create_autocmd('PackChanged', {
  pattern = 'nvim-treesitter',
  desc = 'Update treesitter parsers',
  command = 'TSUpdate'
})

-- NOTE: treesitter features **must** be enabled manually
-- https://github.com/nvim-treesitter/nvim-treesitter#supported-features
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'lua', 'vim', 'help', 'c', 'query', 'bash', 'markdown'},
  callback = function()
    -- Enable treesitter based syntax highlight
    pcall(vim.treesitter.start)
  end
})

-- LSP setup
-- NOTE: mason-lspconfig v2+ dropped `handlers`/`.setup_handlers()`.
-- Servers are enabled automatically (`automatic_enable`, default true)
-- via the native `vim.lsp.config` / `vim.lsp.enable` API instead.
vim.lsp.config('*', {
  capabilities = blink_capabilities,
})

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {'lua_ls', 'bashls', 'marksman'},
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local map = function(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- NOTE: grn/gra/grr/gri/gO/<C-s> are nvim v0.11+ defaults, set manually just for cleaner description
    map('n', 'grr', '<cmd>lua vim.lsp.buf.references()<cr>', "[G]oto [R]eference")
    map('n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<cr>', "[G]oto [I]mplementation")
    map('n', 'grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', "[G]oto [T]ype Definition")
    map('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<cr>', "[R]e[n]ame")
    map('n', 'gra', '<cmd>lua vim.lsp.buf.code_action()<cr>', "[G]oto Code [A]ction")
    -- map('n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', "[G]oto Document Symb[o]l")
    -- map({'i', 's'}, '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', "Open Signature Help")

    -- These are custom keymaps
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', "[G]oto [D]efinition")
    map('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', "[G]oto [D]ecla[r]ation")
    map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', "Hover Code")
    -- vim.keymap.set({'n', 'x'}, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  end,
})
