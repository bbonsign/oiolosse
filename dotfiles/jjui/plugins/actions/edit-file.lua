local function first_hunk_new_lineno(git_diff)
  for line in git_diff:gmatch("[^\n]+") do
    if line:sub(1, 3) == "@@ " then
      local new_start = line:match("%+(%d+)")
      if new_start then
        return tonumber(new_start)
      end
    end
  end
  return nil
end

return {
  name = "edit-file",
  fn = function()
    local file = context.file()
    if not file then
      flash("No file selected")
      return
    end
    local diff = jj("diff", "--git", "-r", context.change_id(), context.file())
    local line_number = first_hunk_new_lineno(diff)
    -- opens at line of first hunk in nvim
    jj_interactive("util", "exec", "--", "bash", "-c", string.format("$EDITOR +%q %q", line_number, context.file()))
  end,
  opts = {
    key = "e",
    -- seq = { "space", "e" },
    scope = "revisions.details",
    desc = "edit selected file",
  },
}
