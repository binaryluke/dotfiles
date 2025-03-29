-- lua/bookmark.lua
local M = {}

-- Internal table to store bookmarks.
-- Keys: numbers (1, 2, 3, ...); Values: table with file, line, and col.
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

return M
