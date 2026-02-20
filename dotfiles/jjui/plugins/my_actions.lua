local M = {}

---@class ActionDef
---@field name string
---@field fn fun()
---@field opts ActionOpts

---@type ActionDef[]
local actions = {
  -- Yanking
  {
    name = "copy-changeid",
    fn = function()
      local change_id = context.change_id()
      if change_id then
        copy_to_clipboard(change_id)
        flash("Copied change ID: " .. change_id)
        return
      end
      flash("No item selected to copy")
    end,
    opts = {
      seq = { "space", "y", "c" },
      desc = "Copy change id",
      scope = "revisions.details",
    },
  },
  {
    name = "copy-changeid-rev",
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
      local change_id = context.change_id()
      if change_id then
        copy_to_clipboard(change_id)
        flash("Copied change ID: " .. change_id)
        return
      end
      flash("No item selected to copy")
    end,
    opts = {
      seq = { "space", "y", "c" },
      desc = "Copy change id",
      scope = "revisions",
    },
  },
  {
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
  },

  -- Tags
  {
    name = "tag-current-change",
    fn = function()
      local change_id = context.change_id()
      if not change_id then
        flash("No change_id")
        return
      end
      local user_input = input({
        title = "Tag name",
        prompt = "Enter a tag_name: ",
      }) or ""
      local tag_name = string.gsub(user_input, "%s", "")
      if not tag_name then
        flash("No tag_name")
        return
      end
      jj("tag", "set", "-r", change_id, tag_name)
      revisions.refresh()
    end,
    opts = {
      seq = { "space", "t", "t" },
      scope = "revisions",
      desc = "tag change under cursor",
    },
  },

  {
    name = "delete-tag",
    fn = function()
      local output, err = jj("tag", "list", "-T", "name ++ '\n'")
      local choice = choose({
        title = "Choose a tag",
        options = split_lines(output),
      })
      if not choice then
        flash("none selected")
        return
      end
      jj("tag", "delete", choice)
      revisions.refresh()
    end,
    opts = {
      seq = { "space", "t", "d" },
      scope = "revisions",
    },
  },

  -- Diffs
  {
    name = "diff-to-bookmark",
    fn = function()
      local change_id = context.change_id()
      if not change_id then
        flash("No change_id")
        return
      end
      local bookmarks, err = jj("bookmark", "list", "-T", "name ++ '\n'")
      local bookmark = choose({
        title = "Choose a bookmark",
        options = split_lines(bookmarks),
      })
      if not bookmark then
        flash("None selected")
        return
      end
      exec_shell("jj diff --from " .. change_id .. " --to " .. bookmark .. " | diffnav")
    end,
    opts = {
      seq = { "space", "d", "d" },
      scope = "revisions",
    },
  },
  {
    name = "diff-to-trunk",
    fn = function()
      local change_id = context.change_id()
      if not change_id then
        flash("No change_id")
        return
      end
      exec_shell("jj diff --from " .. change_id .. " --to 'trunk()' | diffnav")
    end,
    opts = {
      seq = { "space", "d", "t" },
      scope = "revisions",
    },
  },
  {
    name = "deltadiff-revision",
    fn = function()
      local change_id = context.change_id()
      jj_interactive(
        "util",
        "exec",
        "--",
        "bash",
        "-c",
        "jj diff --summary --git --color always -r " .. change_id .. " | diffnav"
      )
    end,
    opts = {
      key = "d",
      scope = "revisions",
    },
  },
  {
    name = "deltadiff",
    fn = function()
      local change_id = context.change_id()
      local file = context.file() or ""
      jj_interactive(
        "util",
        "exec",
        "--",
        "bash",
        "-c",
        "jj diff --summary --git --color always -r " .. change_id .. " " .. file .. " | diffnav"
      )
    end,
    opts = {
      key = "d",
      scope = "revisions.details",
    },
  },

  -- Edit file
  {
    name = "edit-file",
    fn = function()
      local file = context.file()
      if not file then
        flash("No file selected")
        return
      end
      exec_shell("$EDITOR " .. '"' .. file .. '"')
    end,
    opts = {
      seq = { "space", "e" },
      scope = "revisions.details",
      desc = "edit selected file",
    },
  },

  -- Rebase / merge
  {
    name = "rebase-onto-multiple",
    fn = function()
      local change_id = context.change_id()
      local checked = context.checked_commit_ids()
      if not change_id or not checked or #checked == 0 then
        flash("Select a revision and check targets")
        return
      end
      local args = { "rebase", "-s", change_id }
      for _, cid in ipairs(checked) do
        table.insert(args, "--onto")
        table.insert(args, cid)
      end
      jj(args)
      revisions.refresh()
    end,
    opts = {
      seq = { "space", "r", "m" },
      scope = "revisions",
    },
  },

  {
    name = "mark-private-base",
    fn = function()
      local change_id = context.change_id()
      if not change_id then
        flash("No change_id")
        return
      end

      local description = jj("log", "--no-graph", "-r", change_id, "-T", "description")
      local trimmed_description = string.gsub(description or "", "^%s*(.-)%s*$", "%1")
      if trimmed_description ~= "" then
        flash("Revision already has a description")
        return
      end

      local empty_revset = 'change_id("' .. change_id .. '") & empty()'
      local empty_match = jj("log", "--no-graph", "-r", empty_revset, "-T", "change_id")
      local trimmed_empty_match = string.gsub(empty_match or "", "^%s*(.-)%s*$", "%1")
      if trimmed_empty_match == "" then
        flash("Revision is not empty")
        return
      end

      jj("describe", "-r", change_id, "--message", "private: base")
      revisions.refresh()
    end,
    opts = {
      seq = { "space", "m", "b" },
      scope = "revisions",
      desc = "set description to private: base when empty",
    },
  },

  {
    name = "rebase-private-base-to-trunk",
    fn = function()
      local output, err = jj("log", "--no-graph", "-r", 'description("private: base*")', "-T", "change_id ++ '\n'")
      local matches = split_lines(output)
      if not matches or #matches == 0 then
        flash("No revision found with description: private: base")
        return
      end

      local source = matches[1]
      if #matches > 1 then
        source = choose({
          title = "Choose private: base revision",
          options = matches,
        })
        if not source then
          flash("None selected")
          return
        end
      end

      jj("rebase", "--source", source, "--destination", "trunk()")
      revisions.refresh()
    end,
    opts = {
      seq = { "space", "r", "b" },
      scope = "revisions",
      desc = "rebase private: base onto trunk()",
    },
  },

  {
    name = "megamerge",
    fn = function()
      local checked = context.checked_commit_ids()
      if not checked or #checked == 0 then
        flash("Check revisions to merge")
        return
      end
      local args = { "new" }
      for _, cid in ipairs(checked) do
        table.insert(args, cid)
      end
      jj(args)
      revisions.refresh()
    end,
    opts = {
      seq = { "space", "m", "m" },
      scope = "revisions",
    },
  },
  {
    name = "move-commit-down",
    fn = function()
      local change_id = context.change_id()
      local checked = context.checked_commit_ids()
      if not change_id or not checked or #checked == 0 then
        flash("Check revisions to move")
        return
      end
      local args = { "rebase" }
      for _, cid in ipairs(checked) do
        table.insert(args, "-r")
        table.insert(args, cid)
      end
      table.insert(args, "--insert-before")
      table.insert(args, change_id)
      jj(args)
      revisions.refresh()
    end,
    opts = {
      key = "J",
      scope = "revisions",
    },
  },
  {
    name = "move-commit-up",
    fn = function()
      local change_id = context.change_id()
      local checked = context.checked_commit_ids()
      if not change_id or not checked or #checked == 0 then
        flash("Check revisions to move")
        return
      end
      local args = { "rebase" }
      for _, cid in ipairs(checked) do
        table.insert(args, "-r")
        table.insert(args, cid)
      end
      table.insert(args, "--insert-after")
      table.insert(args, change_id)
      jj(args)
      revisions.refresh()
    end,
    opts = {
      key = "K",
      scope = "revisions",
    },
  },

  -- New change
  {
    name = "new-at-trunk",
    fn = function()
      jj("new", "trunk()")
      revisions.refresh()
    end,
    opts = {
      seq = { "space", "n", "t" },
      scope = "revisions",
    },
  },
  {
    name = "new-from-here",
    fn = function()
      local change_id = context.change_id()
      if not change_id then
        flash("No change_id")
        return
      end
      jj("new", change_id)
      revisions.refresh()
    end,
    opts = {
      seq = { "space", "n", "n" },
      scope = "revisions",
    },
  },
  {
    name = "new-after-here",
    fn = function()
      local change_id = context.change_id()
      if not change_id then
        flash("No change_id")
        return
      end
      jj("new", "--insert-after", change_id)
      revisions.refresh()
    end,
    opts = {
      seq = { "space", "n", "a" },
      scope = "revisions",
    },
  },
  {
    name = "new-before-here",
    fn = function()
      local change_id = context.change_id()
      if not change_id then
        flash("No change_id")
        return
      end
      jj("new", "--insert-before", change_id)
      revisions.refresh()
    end,
    opts = {
      seq = { "space", "n", "b" },
      scope = "revisions",
    },
  },
  {
    name = "new-at-branch",
    fn = function()
      local output, err = jj("bookmark", "list", "-T", "name ++ '\n'")
      local bookmark = choose({ options = split_lines(output), title = "choose a bookmark" })
      if bookmark then
        jj("new", "--insert-after", bookmark)
        revisions.refresh()
      else
        flash("none selected")
      end
    end,
    opts = {
      seq = { "space", "n", "ctrl+b" },
      scope = "revisions",
      desc = "new change at branch",
    },
  },

  -- Views (revset shortcuts)
  {
    name = "show-all",
    fn = function()
      revset.set("all()")
    end,
    opts = {
      seq = { "space", "v", "a" },
      scope = "revisions",
      desc = "show all revisions",
    },
  },
  {
    name = "show-tracked",
    fn = function()
      revset.set("tracked_remote_bookmarks()::")
    end,
    opts = {
      seq = { "space", "v", "t" },
      scope = "revisions",
      desc = "show tracked remote bookmarks",
    },
  },
  {
    name = "show-default",
    fn = function()
      revset.set("present(@) | ancestors(immutable_heads().., 2) | present(trunk())")
    end,
    opts = {
      seq = { "space", "v", "d" },
      scope = "revisions",
      desc = "show default revisions",
    },
  },

  -- Rebase source
  {
    name = "rebase-source",
    fn = function()
      revisions.start_rebase({ source = "descendants" })
    end,
    opts = {
      key = "R",
      scope = "revisions",
      desc = "rebase --source current revision",
    },
  },

  -- Copy
  {
    name = "copy-diff",
    fn = function()
      local diff = jj("diff", "-r", context.change_id(), "--git")
      copy_to_clipboard(diff)
    end,
    opts = {
      key = "Y",
      scope = "revisions",
      desc = "copy diff",
    },
  },
}

---@param config Config
function M.setup(config)
  for _, a in ipairs(actions) do
    config.action(a.name, a.fn, a.opts)
  end
end

return M
