return {
  before_init = function(params, config)
    local root = config.root_dir
    local workspace = root and root:match("^(.-/x8%-lambda%.repo/[^/]+)")
    if not workspace or vim.fn.isdirectory(root .. "/src") == 0 then
      return
    end

    -- Each Lambda has its own top-level modules; never combine their src paths.
    params.initializationOptions = vim.tbl_deep_extend("force", params.initializationOptions or {}, {
      pythonPath = workspace .. "/.venv/bin/python",
      pyrefly = { extraSearchPaths = { root .. "/src" } },
    })
  end,
}
