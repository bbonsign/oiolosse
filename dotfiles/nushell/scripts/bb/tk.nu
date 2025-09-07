# Toolkit

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

export def fzy-get [
  column: string = ""
  query: string = ""
  --preview_group_by (-g): string = ""
  --nth: string = ".." # forwared to fzf --nth param, ".." is the default for searching all fields
]: table -> any {
  let in_table = $in
  let in_file = if ($preview_group_by | is-not-empty) {
    $in_table | group-by {$in | get $preview_group_by} 
  } else {
    $in_table
  }
  | table --expand
  | as file

  let columns = $in | columns
  let column = if ($column | is-empty) {
    gum filter --height (($columns | length) + 3 ) ...$columns
  } else {
    $column
  }

  let parser = $columns | each {$"\(?P<($in)>.*\)"} | str join "\t+"

  $in 
  | to tsv 
  | ^column --table --separator "\t" --output-separator "\t" # align columns
  | (fzf 
    --delimiter "\t"
    --nth $nth
    --query $query
    --header-lines 1
    --preview-window 'down,hidden'
    --preview $"bat ($in_file)"
  )
  | parse --regex $parser
  | default {}
  | get $column
  | get 0?
  | default ""
  | str trim
}

export def "datetime from int" []: [
  duration -> datetime
  int -> datetime
  float -> datetime
] {
  $in | into duration --unit ns | into int | into datetime
}

export def "ll" [...args] {
  let args = if ($args | is-empty ) { ["."] } else { $args }
  ls --all --long ...$args | sort-by type name modified  | select name type mode created modified target
}

export def --env "set_aws_profile" [] {
  $env.AWS_PROFILE =  (aws configure list-profiles | fzf)
}

export alias ":ae" = set_aws_profile 
export alias "dtfi" = datetime from int  



def "lines escaped" [] {
  let in_meta = (metadata $in)
  $in | split chars | append { done: true } | generate { |char, acc={ escape: false, text: "" }
    | match [$char, $acc.escape] {
      [{ done: true }, _]       => { out: $acc.text }
      ['\',  false]             => { out: null,      next: { escape: true,  text: ($acc.text + $char) } }
      ["\n", false]             => { out: $acc.text, next: { escape: false, text: "" } }
      [_, false] | ["\n", true] => { out: null,      next: { escape: false, text: ($acc.text + $char) } }
      [$ch, true] => { error make { msg: $"encountered unknown escape: `\\($ch)`.", label: { text: "source of the offending value", span: $in_meta.span } } }
    }
  } | compact
}

# Parse systemd unit files
export def "from systemd-ini" [] {
  lines escaped
  | split list --split before --regex '^\[.*\]$' # split into multiple lists, each containing all lines of a single section, including the header.
  | skip 1 # we assume there's no global section.
  | each { |group| {
    name:     ($group | first | parse '[{name}]' | get 0.name), # unwrap the section name.
    contents: ($group | skip 1 | parse '{key}={value}' | transpose --header-row --as-record --keep-all # parse the individual KV pairs.
      | if ($in | describe | str starts-with "list<") { {} } else { $in } # this unpretty trickery is necessary because `[] | transpose --as-record` unfortunately returns an empty list in nushell.
    )
  } }
  | reduce --fold={} { |sec, acc| $acc | upsert $sec.name { default {} | merge $sec.contents } } # merge all the sections while applying possible overrides.
}


# Search env vars
export def "search env" [query: string] {
  debug env | transpose key value | find $query
}

export alias ":fe" = search env
export alias ":se" = search env

# ripgrep->fzf->vim [QUERY] https://junegunn.github.io/fzf/tips/ripgrep-integration/#wrap-up
export def rg-fzf-nvim [query = ""] {
  $env.SHELL = 'nu'
  let RELOAD = 'rg --column --color=always --smart-case {q}'
  let OPENER = '
  if $env.FZF_SELECT_COUNT == 0 {
    nvim {1} +{2}     # No selection. Open the current line in Vim.
    } else {
    nvim +cw -q {+f}  # Build quickfix list for the selected items.
  }
  '
  ( fzf --disabled --ansi --multi
    --bind $"start:reload:($RELOAD)" --bind $"change:reload:($RELOAD)"
    --bind $"enter:become:($OPENER)" --bind $"ctrl-o:execute:($OPENER)"
    --bind 'ctrl-a:select-all,ctrl-d:deselect-all'
    --delimiter ':'
    --preview 'bat --style=full --color=always --highlight-line {2} {1}'
    --preview-window '~4,+{2}+4/3,<80(up)'
    --query $query )
}
export alias ":ef" = rg-fzf-nvim

export alias ":en" = exec nu
