alias IO.ANSI

IO.puts(
  "#{ANSI.blue()}  #{ANSI.magenta()}   Welcome to Elixir   #{ANSI.blue()}  #{ANSI.reset()}\n"
)

# Editor to open code in using `open` function
System.put_env("ELIXIR_EDITOR", "kitty --execute #{System.fetch_env!("EDITOR")} __FILE__ &")

# Prevent dbg() from adding a breakpoint and dropping into pry
Application.put_env(:elixir, :dbg_callback, {Macro, :dbg, []})

IEx.configure(
  colors: [
    syntax_colors: [
      number: :light_yellow,
      atom: :light_cyan,
      string: :white,
      boolean: :red,
      nil: [:magenta, :bright]
    ],
    ls_directory: :cyan,
    ls_device: :yellow,
    doc_code: :green,
    doc_inline_code: :magenta,
    doc_headings: [:cyan, :underline],
    doc_title: [:yellow, :bright, :underline]
  ],
  default_prompt:
    "#{ANSI.green()}%prefix#{ANSI.reset()}" <>
      "[#{ANSI.magenta()}#{ANSI.reset()}" <>
      "#{ANSI.cyan()}%counter#{ANSI.reset()}]",
  alive_prompt:
    "#{ANSI.green()}%prefix#{ANSI.reset()}" <>
      "(#{ANSI.yellow()}%node#{ANSI.reset()}) " <>
      "[#{ANSI.magenta()}#{ANSI.reset()}" <>
      "#{ANSI.cyan()}%counter#{ANSI.reset()}]",
  history_size: 200,
  inspect: [
    charlists: :as_lists,
    pretty: true,
    limit: 50,
    width: 80
  ],
  width: 80
)

defmodule MyHelpers do
  def cl do
    IEx.Helpers.clear()
  end

  def ll do
    IEx.Helpers.clear()
  end

  @doc """
  Shortcut for:
    `IEx.Helpers.recompile()`
  """
  def rc do
    IEx.Helpers.recompile()
  end
end

import MyHelpers
require Integer
