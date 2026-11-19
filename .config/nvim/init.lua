-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

-- Learn more about Neovim lua api
-- https://neovim.io/doc/user/lua-guide.html
-- https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/

local init_dir = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':h')
local v = vim.version()

-- vim.g.mapleader = vim.keycode('<Space>')  -- leader key
-- vim.g.maplocalleader = vim.keycode('<Space>')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true  -- line number
vim.o.relativenumber = true
vim.o.scrolloff = 15 -- minimum lines before/after cursor
vim.o.ignorecase = true -- case-insensitive searching
vim.o.smartcase = true
vim.o.expandtab = true  -- set tab as spaces
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.showmode = false  -- no show vim mode
vim.o.termguicolors = true  -- 24-bit color
vim.o.updatetime = 250  -- update time
vim.o.timeoutlen = 300  -- key sequence timeout
vim.o.signcolumn = 'yes'  -- sign column (gutter for git/diagnostic/...)
vim.o.splitright = true -- positioning for new split
vim.o.splitbelow = true
vim.o.mouse = 'a' -- enable mouse
vim.o.swapfile = false
vim.o.undofile = true
vim.o.confirm = true  -- confirmation for unsaved buffers
vim.o.inccommand = 'split'  -- :%s/ shows changes in split
vim.o.breakindent = true  -- long line break keeps indentation
vim.o.list = true -- make whitespaces visible as icons
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

if v.minor <= 9 then
  vim.o.have_nerd_font = true
else
  vim.g.have_nerd_font = true
end

if v.minor >= 11 then
  vim.o.winborder = 'rounded'
end

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')  -- clear search highlight on esc

if v.minor <= 10 then
  -- diagnostic keymaps are default from nvim 0.11 onwards
  vim.keymap.set('n', '<C-w>d', '<cmd>lua vim.diagnostic.open_float()<cr>')
  vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
  vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
end

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true, -- diagnostic shows up at the end of the line
  virtual_lines = false, -- underneath the line with virtual lines
  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}


-- highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    local hl = vim.hl or vim.highlight
    hl.on_yank()
  end,
})

-- ========================================================================== --
-- ==                          VERSION DISPATCHER                          == --
-- ========================================================================== --

-- Loads the init file matching the running Neovim version, skip if not found

local file
if v.minor >= 12 then
  file = 'init-v0_12.lua'
elseif v.minor == 11 then
  file = 'init-v0_11.lua'
elseif v.minor == 10 or v.minor == 9 then
  file = 'init-v0_9-v0_10.lua'
end

if not file then
  local nvim_version_str = string.format('v%d.%d.%d', v.major, v.minor, v.patch)
  vim.notify('No supported init file for ' .. nvim_version_str, vim.log.levels.ERROR)
  return
end

dofile(init_dir .. '/' .. file)
