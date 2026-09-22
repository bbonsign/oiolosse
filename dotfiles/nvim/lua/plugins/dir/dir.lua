-- Customizing builting dir plugin for directory buffers

-- Delete directory buffers after leaving them.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "directory",
  callback = function(event)
    vim.bo[event.buf].bufhidden = "delete"
  end,
})
