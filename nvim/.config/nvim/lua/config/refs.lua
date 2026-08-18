-- Reference-copying helpers for the <leader>p* keymaps in keymaps.lua:
-- shareable pointers to "this exact line/selection" as a GitHub permalink
-- (commit-pinned or branch-pinned) or a plain local file:line, plus a
-- Python import-path helper. Kept out of keymaps.lua since these need
-- actual git shell-outs, not just vim.* calls.
local M = {}

local function system(cmd)
  local out = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(out)
end

local function git_root()
  return system({ "git", "rev-parse", "--show-toplevel" })
end

local function relpath(root, file)
  return file:sub(#root + 2)
end

-- Every remote actually on github.com, not just "origin" -- this repo's
-- own origin is a private server with a separate "github" remote for the
-- public mirror, and forks/multi-remote setups can have more than one
-- github.com candidate too.
local function github_remotes()
  local remotes = vim.fn.system({ "git", "remote", "-v" })
  if vim.v.shell_error ~= 0 then
    return {}
  end
  local seen, out = {}, {}
  for line in remotes:gmatch("[^\n]+") do
    local name, url = line:match("(%S+)%s+(%S+)%s+%(fetch%)")
    if name and url and url:find("github%.com") and not seen[name] then
      local owner_repo = url:match("github%.com[:/](.-)%.git$") or url:match("github%.com[:/](.-)$")
      if owner_repo then
        seen[name] = true
        table.insert(out, { name = name, owner_repo = owner_repo })
      end
    end
  end
  return out
end

-- Valid while still in Visual mode (called before the keymap wrapper
-- manually leaves it) -- line("v")/line(".") give both ends of the
-- selection without needing to touch the '</'> marks.
local function line_range()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    local s, e = vim.fn.line("v"), vim.fn.line(".")
    if s > e then
      s, e = e, s
    end
    return s, e
  end
  local l = vim.fn.line(".")
  return l, l
end

local function line_fragment(s, e)
  if s == e then
    return "L" .. s
  end
  return "L" .. s .. "-L" .. e
end

local function warn_if_dirty(root, rel)
  vim.fn.system({ "git", "-C", root, "diff", "--quiet", "HEAD", "--", rel })
  if vim.v.shell_error ~= 0 then
    vim.notify("refs: file has uncommitted changes -- link may not match what's on GitHub", vim.log.levels.WARN)
  end
end

local function yank(text, label)
  vim.fn.setreg("+", text)
  vim.fn.setreg('"', text)
  vim.notify(label .. ": " .. text)
end

---@param ref_kind "commit"|"branch"
---@param owner_repo string
local function finish_github_link(ref_kind, owner_repo, root, rel, s, e)
  warn_if_dirty(root, rel)
  local ref
  if ref_kind == "commit" then
    ref = system({ "git", "-C", root, "rev-parse", "HEAD" })
  else
    ref = system({ "git", "-C", root, "rev-parse", "--abbrev-ref", "HEAD" })
  end
  if not ref then
    vim.notify("refs: couldn't resolve " .. ref_kind, vim.log.levels.ERROR)
    return
  end
  local url = ("https://github.com/%s/blob/%s/%s#%s"):format(owner_repo, ref, rel, line_fragment(s, e))
  yank(url, "GitHub (" .. ref_kind .. ")")
end

---@param ref_kind "commit"|"branch"
function M.github_link(ref_kind)
  local root = git_root()
  if not root then
    vim.notify("refs: not inside a git repo", vim.log.levels.ERROR)
    return
  end
  local remotes = github_remotes()
  if #remotes == 0 then
    vim.notify("refs: no github.com remote found", vim.log.levels.ERROR)
    return
  end
  local file = vim.api.nvim_buf_get_name(0)
  local rel = relpath(root, file)
  local s, e = line_range()
  if #remotes == 1 then
    finish_github_link(ref_kind, remotes[1].owner_repo, root, rel, s, e)
    return
  end
  vim.ui.select(remotes, {
    prompt = "Which remote?",
    format_item = function(r)
      return ("%s (%s)"):format(r.name, r.owner_repo)
    end,
  }, function(choice)
    if choice then
      finish_github_link(ref_kind, choice.owner_repo, root, rel, s, e)
    end
  end)
end

function M.local_link()
  local file = vim.api.nvim_buf_get_name(0)
  local s, e = line_range()
  local text = s == e and ("%s:%d"):format(file, s) or ("%s:%d-%d"):format(file, s, e)
  yank(text, "Local ref")
end

-- Walks up from the file's directory while __init__.py is present -- same
-- heuristic pyright/pytest use to find a package's actual import root,
-- stopping at the first ancestor directory that isn't itself a package.
function M.python_import_path()
  local file = vim.api.nvim_buf_get_name(0)
  if not file:match("%.py$") then
    vim.notify("refs: not a python file", vim.log.levels.WARN)
    return
  end
  local dir = vim.fn.fnamemodify(file, ":h")
  local base = vim.fn.fnamemodify(file, ":t:r")
  local parts = {}
  if base ~= "__init__" then
    table.insert(parts, base)
  end
  while vim.fn.filereadable(dir .. "/__init__.py") == 1 do
    table.insert(parts, 1, vim.fn.fnamemodify(dir, ":t"))
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  if #parts == 0 then
    vim.notify("refs: nothing to import (bare __init__.py with no package)", vim.log.levels.WARN)
    return
  end
  yank(table.concat(parts, "."), "Python import path")
end

return M
