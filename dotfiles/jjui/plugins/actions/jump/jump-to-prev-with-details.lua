return {
  name = "jump-to-prev-with-details",
  fn = function()
    revisions.details.close()
    revisions.jump_to_parent()
    revisions.open_details()
  end,
  opts = {
    key = "ctrl+j",
    scope = "revisions.details",
  },
}
