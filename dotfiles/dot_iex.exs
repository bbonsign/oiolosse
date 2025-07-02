#
# NOTE: 
# In project-specific .iex.exs files, include:
# ```
# import_file("~/.iex.exs") 
# ```
# in the project's version to include this config

alias IO.ANSI

IO.puts("#{ANSI.blue()}  #{ANSI.magenta()}  Elixir IEx #{ANSI.blue()}  #{ANSI.reset()}\n")

# Editor to open code in using `open` function
System.put_env("ELIXIR_EDITOR", "kitty #{System.fetch_env!("EDITOR")} __FILE__ &")

IEx.configure(
  auto_reload: true,
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
      "(#{ANSI.yellow()}%node#{ANSI.reset()})" <>
      "[#{ANSI.magenta()}#{ANSI.reset()}" <>
      "#{ANSI.cyan()}%counter#{ANSI.reset()}]",
  history_size: 200,
  inspect: [
    # charlists: :as_strings,
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

  @doc """
  Shortcut for:
  `IEx.Helpers.recompile()`
  """
  def cc do
    IEx.Helpers.recompile()
  end
  @doc """
  Load applications needed to run observer
  """
  def obs do
    [
      # :wx,            # Not necessary on Erlang/OTP 27+
      # :runtime_tools  # Not necessary on Erlang/OTP 27+
      :observer,
    ]
    |> Enum.map(&Mix.ensure_application!/1)
  end

  # @doc """
  # Shortcut to start observer
  # """
  # def obss do
  #   obs()
  #   :observer.start()
  # end
end

import MyHelpers
require Integer
