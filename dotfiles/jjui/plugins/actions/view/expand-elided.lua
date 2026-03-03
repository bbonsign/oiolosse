return {
  name = "expand-elided",
  fn = function()
    local change_id = context.change_id()
    if not change_id then
      flash("No change selected")
      return
    end

    local current = revset.current()
    local ancestor_expr = "ancestors(" .. change_id .. ", 2)"
    if current:find(ancestor_expr, 1, true) then
      return
    end
    revset.set(current .. " | " .. ancestor_expr)
    revisions.refresh({ selected_revision = change_id })
  end,
  opts = {
    seq = { "space", "e" },
    scope = "revisions",
    desc = "expand elided revisions",
  },
}
