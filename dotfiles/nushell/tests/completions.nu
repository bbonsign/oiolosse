# Run with Nushell 0.116.1+ and fzf: nu -n dotfiles/nushell/tests/completions.nu
use std/assert
use ../scripts/bb/complete.nu *

def branches [] {
  [
    {value: main description: "default branch"}
    {value: maple description: "another branch"}
  ]
}
def choose [branch?: string@branches --raw] {}
alias co = choose

$env.config.completions.algorithm = "fuzzy"
$env.FZF_DEFAULT_OPTS = "--filter=main"

# Exercise the actual completion engine and fzf, including descriptions. The
# selected value must not be reconstructed from its fuzzy match or display row.
for case in [
  {buffer: "choose mi" start: 7 end: 9}
  {buffer: "choose  mi" start: 8 end: 10}
  {buffer: "echo é | choose mi" start: 17 end: 19}
  {buffer: "co mi" start: 3 end: 5}
] {
  let result = fzf_menu_source $case.buffer
  assert equal ($result | length) 1
  assert equal $result.0.value main
  assert equal $result.0.span {start: $case.start end: $case.end}
}

# No suggestions and a dismissed picker both return no menu entries, never a
# suggestion containing an empty command line.
assert equal (fzf_menu_source "choose zz") []
with-env {FZF_DEFAULT_OPTS: "--filter=not-a-candidate"} {
  assert equal (fzf_menu_source "choose ma") []
}

# Argument completion must use the command's flags, not suggest command names.
with-env {FZF_DEFAULT_OPTS: "--filter=raw"} {
  let result = fzf_menu_source "choose --ra"
  assert equal $result.0.value "--raw"
  assert equal $result.0.span {start: 7 end: 11}
}

# A provider's display label and description must not replace its real value.
def display-completion [] {
  [{value: '"my file"' display_override: "friendly label" description: "first line\nsecond line"}]
}
def display-command [arg: string@display-completion] {}
with-env {FZF_DEFAULT_OPTS: "--filter=friendly"} {
  let result = fzf_menu_source "display-command "
  assert equal $result.0.value '"my file"'
  assert equal $result.0.span {start: 16 end: 16}
}

print "Completion regression checks passed"
