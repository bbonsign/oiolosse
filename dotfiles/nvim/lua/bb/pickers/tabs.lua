-- Custom tabs picker source, modeled on the builtin `buffers` source.
-- Shows: tab number, current-tab marker, custom name (set via
-- :LualineRenameTab / stored in the `tabname` tabpage var), and the
-- file in the tab's active window. Extra window count shown as "+N".
return {
  finder = function(opts, ctx)
    local items = {}
    local current = vim.api.nvim_get_current_tabpage()
    for i, tabid in ipairs(vim.api.nvim_list_tabpages()) do
      local win = vim.api.nvim_tabpage_get_win(tabid)
      local buf = vim.api.nvim_win_get_buf(win)
      local file = vim.api.nvim_buf_get_name(buf)
      local ok, tabname = pcall(vim.api.nvim_tabpage_get_var, tabid, "tabname")
      local label = (ok and type(tabname) == "string" and tabname ~= "") and tabname or nil
      local cursor = vim.api.nvim_win_get_cursor(win)
      items[#items + 1] = {
        idx = i,
        tabid = tabid,
        tabnr = i,
        buf = buf,
        file = file ~= "" and file or nil,
        label = label,
        current = tabid == current,
        nwins = #vim.api.nvim_tabpage_list_wins(tabid),
        pos = { cursor[1], cursor[2] },
        text = table.concat({ i, label or "", vim.fn.fnamemodify(file, ":t") }, " "),
      }
    end
    return ctx.filter:filter(items)
  end,
  format = function(item, picker)
    local ret = {}
    ret[#ret + 1] = { Snacks.picker.util.align(tostring(item.tabnr), 3), "SnacksPickerIdx" }
    ret[#ret + 1] = { " " }
    ret[#ret + 1] = { item.current and "●" or " ", "SnacksPickerSelected" }
    ret[#ret + 1] = { " " }
    if item.label then
      ret[#ret + 1] = { item.label, "SnacksPickerLabel" }
      ret[#ret + 1] = { " " }
    end
    vim.list_extend(ret, Snacks.picker.format.filename(item, picker))
    if item.nwins > 1 then
      ret[#ret + 1] = { ("+%d"):format(item.nwins - 1), "SnacksPickerComment" }
    end
    return ret
  end,
  preview = "file",
  -- preview window hidden by default (toggle with the preview keymap)
  layout = { preview = false },
  confirm = function(picker, item)
    picker:close()
    if item and vim.api.nvim_tabpage_is_valid(item.tabid) then
      vim.api.nvim_set_current_tabpage(item.tabid)
    end
  end,
  actions = {
    tab_close = function(picker, item)
      if item and vim.api.nvim_tabpage_is_valid(item.tabid) then
        vim.cmd(vim.api.nvim_tabpage_get_number(item.tabid) .. "tabclose")
        picker:refresh()
      end
    end,
  },
  win = {
    input = { keys = { ["<c-x>"] = { "tab_close", mode = { "n", "i" } } } },
    list = { keys = { ["dd"] = "tab_close" } },
  },
}
