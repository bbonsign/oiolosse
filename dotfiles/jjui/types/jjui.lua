---@meta

-- Command Execution

---Execute a jj command synchronously and return its output.
---@param ... string Command arguments (e.g., "log", "-r", "@")
---@return string output Command output
---@return string|nil error Error message, or nil on success
function jj(...) end

---Execute a jj command asynchronously (fire-and-forget).
---@param ... string Command arguments
function jj_async(...) end

---Execute a jj command interactively in the terminal (e.g., split, absorb).
---@param ... string Command arguments
function jj_interactive(...) end

---Run a shell command.
---@param command string The shell command to execute
function exec_shell(command) end

-- User Interface

---Display a temporary flash message to the user.
---@param message string|{text: string, error?: boolean, sticky?: boolean} The message or options table
---@overload fun(opts: {text: string, error?: boolean, sticky?: boolean})
function flash(message) end

---Show a selection menu and wait for the user's choice.
---@param ... string Options to choose from
---@return string|nil choice The selected option, or nil if cancelled
---@overload fun(opts: {options: string[], title?: string}): string|nil
function choose(...) end

---Show an input prompt and wait for user input.
---@param opts {title?: string, prompt?: string} Input options
---@return string|nil text The entered text, or nil if cancelled
function input(opts) end

-- Utilities

---Copy text to the system clipboard.
---@param text string Text to copy
---@return boolean ok Whether the copy succeeded
---@return string|nil error Error message on failure
function copy_to_clipboard(text) end

---Split text into an array of lines.
---@param text string Text to split
---@param keep_empty? boolean Keep empty lines (default: false)
---@return string[] lines Array of lines
function split_lines(text, keep_empty) end

-- Scopes

---@alias Scope
---| '"bookmarks"'
---| '"choose"'
---| '"diff"'
---| '"file_search"'
---| '"git"'
---| '"input"'
---| '"oplog"'
---| '"oplog.quick_search"'
---| '"password"'
---| '"redo"'
---| '"revisions"'
---| '"revisions.abandon"'
---| '"revisions.ace_jump"'
---| '"revisions.details"'
---| '"revisions.details.confirmation"'
---| '"revisions.duplicate"'
---| '"revisions.evolog"'
---| '"revisions.inline_describe"'
---| '"revisions.quick_search"'
---| '"revisions.quick_search.input"'
---| '"revisions.rebase"'
---| '"revisions.revert"'
---| '"revisions.set_bookmark"'
---| '"revisions.set_parents"'
---| '"revisions.squash"'
---| '"revisions.target_picker"'
---| '"revset"'
---| '"status.input"'
---| '"ui"'
---| '"ui.preview"'
---| '"undo"'

-- Setup

---Called by jjui to initialize configuration. Define this in your config.lua.
---@param config Config
function setup(config) end

-- Config

---@class Config
local Config = {}

---Register a custom Lua action, optionally with an inline binding.
---@param name string Action name
---@param fn fun() The function to execute
---@param opts? ActionOpts Optional binding options
function Config.action(name, fn, opts) end

---Add a binding for an action defined elsewhere (TOML or another config.action call).
---@param opts BindOpts Binding options
function Config.bind(opts) end

---@class BindOpts
---@field action string The action name (built-in or custom, e.g., "ui.open_revset")
---@field key? string|string[] Key or array of keys (mutually exclusive with seq)
---@field seq? string[] Multi-key sequence, min 2 keys (mutually exclusive with key)
---@field scope Scope Where the binding is active
---@field desc? string Label shown in the status bar help

---@class ActionOpts
---@field key? string|string[] Key or array of keys (mutually exclusive with seq)
---@field seq? string[] Multi-key sequence, min 2 keys (mutually exclusive with key)
---@field scope? Scope Where the binding is active (required when key or seq is set)
---@field desc? string Label shown in the status bar help

-- Context API

---@class context
context = {}

---Returns the change ID of the currently selected revision.
---@return string|nil change_id
function context.change_id() end

---Returns the commit ID of the currently selected revision.
---@return string|nil commit_id
function context.commit_id() end

---Returns the currently selected file path (in details view).
---@return string|nil file
function context.file() end

---Returns the currently selected operation ID (in oplog view).
---@return string|nil operation_id
function context.operation_id() end

---Returns an array of checked file paths.
---@return string[]|nil files
function context.checked_files() end

---Returns an array of checked change IDs.
---@return string[]|nil change_ids
function context.checked_change_ids() end

---Returns an array of checked commit IDs.
---@return string[]|nil commit_ids
function context.checked_commit_ids() end

-- Revisions API

---@class revisions
revisions = {}

---Returns the change ID of the currently selected revision.
---@return string|nil change_id
function revisions.current() end

---Returns an array of checked revision change IDs.
---@return string[] change_ids
function revisions.checked() end

---Open the details view for the selected revision.
function revisions.open_details() end

---Refresh the revision list.
---@param opts? {keep_selections?: boolean, selected_revision?: string}
function revisions.refresh(opts) end

---Navigate the revision list.
---@param opts {by?: integer, page?: boolean, target?: "parent"|"child"|"working_copy", to?: string, fallback?: string, ensureView?: boolean, allowStream?: boolean}
function revisions.navigate(opts) end

---Initiate a squash operation.
---@param opts? {files?: string[]}
function revisions.start_squash(opts) end

---Initiate a rebase operation.
---@param opts? {source?: "revision"|"branch"|"descendants", target?: "destination"|"after"|"before"|"insert"}
function revisions.start_rebase(opts) end

---Open inline editor to change the description. Yields until editor is closed.
---@return boolean applied True if the description was applied
function revisions.start_inline_describe() end

-- Revset API

---@class revset
revset = {}

---Returns the current revset expression.
---@return string expression
function revset.current() end

---Returns the default revset expression from config.
---@return string expression
function revset.default() end

---Set a new revset expression.
---@param expression string
function revset.set(expression) end

---Reset to the default revset.
function revset.reset() end
