return {
  name = "copy-filepath",
  fn = function()
    local checked_files = context.checked_files()
    if checked_files and #checked_files > 0 then
      local file_names = table.concat(checked_files, " ")
      copy_to_clipboard(file_names)
      flash("Copied checked files: " .. file_names)
      return
    end
    local selected_file = context.file()
    if selected_file then
      copy_to_clipboard(selected_file)
      flash("Copied file: " .. selected_file)
      return
    end
    flash("No item selected to copy")
  end,
  opts = {
    seq = { "space", "y", "f" },
    desc = "Copy change id or file path",
    scope = "revisions.details",
  },
}
