local helpers = require("plugins.helpers")

return {
  name = "megamerge-remove-parents",
  fn = function()
    local megamerge = helpers.find_or_choose_megamerge()
    if not megamerge then
      return
    end

    local targets = helpers.checked_targets_excluding(megamerge)
    if not targets then
      flash("Check parent revisions to remove")
      return
    end

    local destination_revset = megamerge .. "-"
    for _, cid in ipairs(targets) do
      destination_revset = destination_revset .. " ~ " .. cid
    end

    jj("rebase", "--source", megamerge, "--onto", destination_revset)
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "m", "m", "d" },
    scope = "revisions",
    desc = "remove checked revisions from megamerge parents",
  },
}
