vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Explicit rather than relying on Neovim 0.10+'s terminal-capability
-- auto-detection (based on $COLORTERM/terminfo) -- that default is a good
-- fallback but shouldn't be the only thing standing between a hex-based
-- colorscheme (kanagawa) and correct rendering.
vim.o.termguicolors = true

vim.o.number = true
vim.o.relativenumber = true

-- Without this, yank/delete only ever touches nvim's own internal unnamed
-- register -- never the OS clipboard -- so `y` in nvim and Cmd-V elsewhere
-- look completely disconnected. `unnamedplus` (the `+` register) is the
-- correct target on macOS/Linux (X11's `unnamed`/`*` selection is a
-- separate, X11-specific concept nvim also supports but doesn't apply
-- here). This fixes the local case; tmux's own clipboard passthrough
-- (still open in the tmux backlog) is a separate concern for when nvim is
-- running inside tmux specifically.
vim.o.clipboard = "unnamedplus"
