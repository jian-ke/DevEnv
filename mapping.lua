require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local unmap = vim.keymap.del

local n_opts = {silent = true, noremap = true}
local t_opts = {silent = true}

unmap("n", "<leader>n")
unmap("n", "<C-C>")

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

function LiveGrepGitDir()
  local git_dir = vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
  git_dir = string.gsub(git_dir, "\n", "") -- remove newline character from git_dir

  local stat = vim.uv.fs_stat(git_dir)
  if not (stat and stat.type) then
    git_dir = './'
  end

  local opts = {
    cwd = git_dir,
  }
  require('telescope.builtin').live_grep(opts)
end

function LiveGrepStringGitDir()
  local git_dir = vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
  git_dir = string.gsub(git_dir, "\n", "") -- remove newline character from git_dir

  local stat = vim.uv.fs_stat(git_dir)
  if not (stat and stat.type) then
    git_dir = './'
  end

  local opts = {
    cwd = git_dir,
  }
  require('telescope.builtin').grep_string(opts)
end



function LiveFindGitDir()
  local git_dir = vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
  git_dir = string.gsub(git_dir, "\n", "") -- remove newline character from git_dir

  local stat = vim.uv.fs_stat(git_dir)
  if not (stat and stat.type) then
    git_dir = './'
  end

  local opts = {
    cwd = git_dir,
  }
  require('telescope.builtin').find_files(opts)
end

-- local hop = require('hop')
-- local directions = require('hop.hint').HintDirection
-- vim.keymap.set('', 'f', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
-- end, {remap=true})
-- vim.keymap.set('', 'F', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
-- end, {remap=true})
-- vim.keymap.set('', 't', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
-- end, {remap=true})
-- vim.keymap.set('', 'T', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
-- end, {remap=true})


map('n', '<leader>ff', '<cmd>lua LiveFindGitDir()<CR>', {desc = "Telescope Find file in git dir"})
map('n', '<leader>ss', '<cmd>lua LiveGrepStringGitDir()<CR>', {desc = "Telescope Search word in git dir"})
map('n', '<leader>sf', '<cmd>lua LiveGrepGitDir()<CR>', {desc = "Telescope Search word in git dir"})
map('n', '<C>-/', 'gcc', {desc = "Comment toggle"})
map('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', {desc = "LSP rename variable in buffer"})
local gitsigns = require('gitsigns')
map('n', '<leader>gb', gitsigns.toggle_current_line_blame, {desc = "gitsign toggle line blame"})

map('t' , '<esc>'     , '<C-\\><C-N>'      , t_opts)
map('t' , '<C-Left>'  , '<C-\\><C-N><C-w>h', t_opts)
map('t' , '<C-Down>'  , '<C-\\><C-N><C-w>j', t_opts)
map('t' , '<C-Up>'    , '<C-\\><C-N><C-w>k', t_opts)
map('t' , '<C-Right>' , '<C-\\><C-N><C-w>l', t_opts)

require('leap').set_default_mappings()


local plugin = require "telescope"

plugin.setup({
  extensions = {
    aerial = {
      -- How to format the symbols
      backends = { "lsp", "markdown", "asciidoc", "man" },
      format_symbol = function(symbol_path, filetype)
        if filetype == "json" or filetype == "yaml" or filetype == "cpp" then
          return table.concat(symbol_path, ".")
        else
          return symbol_path[#symbol_path]
        end
      end,
      -- Available modes: symbols, lines, both
      show_columns = "both",
    },
  },
})

plugin.load_extension("live_grep_args")
plugin.load_extension("git_file_history")
