return {
  name = "jump-to-next-with-details",
  fn = function()
    revisions.details.close()
    revisions.jump_to_children()
    revisions.open_details()
  end,
  opts = {
    key = "ctrl+k",
    scope = "revisions.details",
  },
}
