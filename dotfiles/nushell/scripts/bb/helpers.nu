use std

# Allows for replicating process substituion.
# Example:
#   nvim --cmd copen -q (ruff check --output-format concise | as file )
#
# In bash, this would be `nvim --cmd copen -q <(ruff check --output-format concise)`
# From https://github.com/nushell/nushell/issues/10610
export def "as file" [] {
  let it = $in
  # make tmp file in system tmp dir
  let file = mktemp --tmpdir
  $it | save --append $file # Need to run it in background for it to stream, but this also works (but doesn't provide streaming).
  $file
}

export def wrap_commandline_in_nvim_quickfix [] {
  let current_commandline = commandline
  if (($current_commandline | str trim ) == "") { return $current_commandline }
  commandline edit $"nvim --cmd copen -q \(($current_commandline) | as file\)"
}

# Get help on commands using fzf
export def ":help" [query: string = ""] {
  do {
    help commands | where command_type == built-in
    | each {|cmd|
      let search_terms = if ($cmd.search_terms == "") {""} else {$"\(($cmd.search_terms))"}
      let category = if ($cmd.category == "") {""} else {$"\(Category: ($cmd.category))"}
      $"(ansi default)($cmd.name?)\t(ansi light_blue) ($cmd.usage?) (ansi cyan)($search_terms) ($category)(ansi reset)" }
    | to text
    | (
      fzf
      --ansi
      --query $query
      --tiebreak=begin,end,chunk 
      --exact --preview=`^echo -n {} | nu --stdin -c "help ($in | split row '\t' | get 0)"`
      --bind 'ctrl-/:change-preview-window(right,70%|right)'
      --bind "enter:become(help ({}| split row '\t' | get 0 | str trim))"
    )
  }
}

export def ":search" [query: string = ""] {
  let RELOAD = 'reload:rg --column --color=always --smart-case {q}'
  try {
    (fzf --disabled
      --ansi
      --query $query
      --bind $"start:($RELOAD)"
      --bind $"change:($RELOAD)"
      --bind 'enter:become:nvim {1} +{2}'
      --bind 'ctrl-y:execute-silent(^echo -n {} | cb )+accept'
      --delimiter :
      --preview 'bat --style=full --color=always --highlight-line {2} {1}'
      --preview-window '~4,+{2}+4/3,<80(up)'
    )
  } catch {|e|
    # ctrl-c
    ignore
  }
}

export def "fg status" []  {
  try {
    git rev-parse --git-dir e> (std null-device)
  } catch {
    print "Not in a git repo";
    return ""
  }
  def parse-status [status_line: string]  {
    $status_line | split row ' ' | last
  }
  let preview_cmd = "git diff --color {-1} | delta --config ~/.config/git/config"
  let selections = git -c color.status=always status --short
  | (
    fzf-tmux
    --ansi
    --multi
    --cycle
    --prompt "Git Status> "
    # --query (commandline --current-token)
    --preview-window '~4,+{2}+4/3,<80(up)'
    --preview $preview_cmd
    --nth "2.."
  )
  | lines
  | each {parse-status $in }

  $selections | str join " "
}

export def "fg branches" [
  query: string = ""
  --all
] {
  try {
    git rev-parse --git-dir o+e> (std null-device)
  } catch {
    print "Not in a git repo";
    return ""
  }
  alias gradient-local = ansi gradient --fgend '0xbb9af7' --fgstart '0x7aa2f7'
  alias gradient-remote = ansi gradient --fgend '0x7aa2f7' --fgstart '0xbb9af7'
  let branches = if $all {
    [...(git for-each-ref --format='Local:%09%(refname:strip=2)' --sort=-committerdate refs/heads/ | lines | each {$in | gradient-local}) ...(git for-each-ref --format='Remote:%09%(refname:strip=2)' refs/remotes/ | lines | each {$in | gradient-remote})]
  } else {
    [...(git for-each-ref --format='Local:%09%(refname:strip=2)' --sort=-committerdate refs/heads/ | lines | each {$in | gradient-local})]
  }

  $branches
  | to text
  | (fzf-tmux
    --ansi
    --cycle
    --prompt "Git Branches> "
    --query $query
  )
  | parse --regex '(?P<location>\w+):\s*(?P<branch>.+$)'
  | default {}
  | do {
    if ($in.location?.0? | default "" | str trim) =~ "Remote" {
      $in.branch  | parse "{remote}/{branch}" | get branch.0
    } else {
      $in.branch?.0? | default ""
    }
  }
}
