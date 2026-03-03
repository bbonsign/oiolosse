local helpers = require("plugins.helpers")

return {
  name = "megamerge-add-parents",
  fn = function()
    local megamerge = helpers.find_or_choose_megamerge()
    if not megamerge then
      return
    end

    local targets = helpers.checked_targets_excluding(megamerge)
    if not targets then
      flash("Check revisions to add as parents")
      return
    end

    local args = {
      "rebase",
      "--source",
      megamerge,
      "--onto",
      megamerge .. "-",
    }
    for _, cid in ipairs(targets) do
      table.insert(args, "--onto")
      table.insert(args, cid)
    end

    jj(args)
    revisions.refresh()
  end,
  opts = {
    seq = { "space", "m", "m", "a" },
    scope = "revisions",
    desc = "add checked revisions as megamerge parents",
  },
}
