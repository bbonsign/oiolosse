---@param increment boolean
---@param g? boolean
local function dial(increment, g)
  local mode = vim.fn.mode(true)
  -- Use visual commands for VISUAL 'v', VISUAL LINE 'V' and VISUAL BLOCK '\22'
  local is_visual = mode == "v" or mode == "V" or mode == "\22"
  local func = (increment and "inc" or "dec") .. (g and "_g" or "_") .. (is_visual and "visual" or "normal")
  local group = vim.g.dials_by_ft[vim.bo.filetype] or "default"
  return require("dial.map")[func](group)
end

-- enabled as lazyvim extra
return {
  "monaqa/dial.nvim",
  keys = function()
    return {
      {
        "<C-s>",
        function()
          return dial(true)
        end,
        expr = true,
        desc = "Increment",
        mode = { "n", "v" },
      },
      {
        "<C-x>",
        function()
          return dial(false)
        end,
        expr = true,
        desc = "Decrement",
        mode = { "n", "v" },
      },
      {
        "g<C-s>",
        function()
          return dial(true, true)
        end,
        expr = true,
        desc = "Increment",
        mode = { "n", "v" },
      },
      {
        "g<C-x>",
        function()
          return dial(false, true)
        end,
        expr = true,
        desc = "Decrement",
        mode = { "n", "v" },
      },
    }
  end,
}
