vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Explicit rather than relying on Neovim's terminal-capability auto-detect.
vim.o.termguicolors = true

vim.o.number = true
vim.o.relativenumber = true

-- `unnamedplus` routes yank/delete to the OS clipboard, not just nvim's
-- own internal register.
vim.o.clipboard = "unnamedplus"

-- Search: case-insensitive by default, but any uppercase letter in the
-- pattern flips it to case-sensitive (smartcase only applies with
-- ignorecase on). To force an all-lowercase search to stay case-sensitive
-- anyway, add \C anywhere in the pattern, e.g. /foo\C -- matches "foo"
-- only, not "Foo"/"FOO" (\c does the reverse: forces case-insensitive
-- regardless of these settings). Vim built-in, no mapping needed.
vim.o.ignorecase = true
vim.o.smartcase = true
