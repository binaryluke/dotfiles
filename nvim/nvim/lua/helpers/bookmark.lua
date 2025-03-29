-- lua/bookmark.lua
local M = {}

-- Internal table to store bookmarks.
-- Keys: slot numbers; Values: { file, line, col }
local bookmarks = {}

-- Bookmark the current file and cursor position into a given slot.
function M.bookmark(pos)
  local file = vim.fn.expand('%:p')
  if file == "" then
    print("Current buffer is not associated with a file!")
    return
  end
  bookmarks[pos] = {
    file = file,
    line = vim.fn.line('.'),
    col = vim.fn.col('.')
  }
  print("Bookmarked " .. file .. " at slot " .. pos .. " (line " .. bookmarks[pos].line .. ")")
end

-- Jump to the bookmarked file and position.
function M.goto(pos)
  local bm = bookmarks[pos]
  if not bm then
    print("No bookmark set at position " .. pos)
    return
  end
  if vim.fn.filereadable(bm.file) == 0 then
    print("File " .. bm.file .. " is not readable or does not exist")
    return
  end
  vim.cmd("edit " .. bm.file)
  vim.api.nvim_win_set_cursor(0, { bm.line, bm.col - 1 })
end

-- Auto-update the bookmark when leaving a buffer.
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*",
  callback = function()
    local file = vim.fn.expand('%:p')
    for pos, bm in pairs(bookmarks) do
      if bm.file == file then
        bookmarks[pos].line = vim.fn.line('.')
        bookmarks[pos].col = vim.fn.col('.')
      end
    end
  end
})

--- Returns a sorted list of bookmarked files.
-- Each entry is a table with slot, file, line, and col.
function M.get_bookmarked_files()
  local list = {}
  for pos, bm in pairs(bookmarks) do
    table.insert(list, { slot = pos, file = bm.file, line = bm.line, col = bm.col })
  end
  table.sort(list, function(a, b) return a.slot < b.slot end)
  return list
end

--- Launches an fzf-lua picker to browse bookmarked files.
-- Selecting an entry will jump to that bookmark.
function M.fzf_bookmarks()
  local fzf = require('fzf-lua')
  local items = {}
  local mapping = {}

  local bookmarks_list = M.get_bookmarked_files()
  for _, bm in ipairs(bookmarks_list) do
    local display = string.format("%d: %s (line %d)", bm.slot, bm.file, bm.line)
    table.insert(items, display)
    mapping[display] = bm.slot
  end

  fzf.fzf_exec(items, {
    prompt = 'Bookmarks> ',
    actions = {
      ['default'] = function(selected)
        if selected and #selected > 0 then
          local sel = selected[1]
          local pos = mapping[sel]
          if pos then
            M.goto(pos)
          end
        end
      end,
    },
  })
end

return M
