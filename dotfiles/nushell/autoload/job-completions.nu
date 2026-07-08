# Completions for `job unfreeze`, sourced from the `id`/`description` columns
# of `job list` (only frozen jobs can be unfrozen).

# Alias to the builtin, defined *before* shadowing so it keeps pointing at the
# real command instead of recursing into the wrapper below.
alias job-unfreeze-builtin = job unfreeze

def "nu-complete job ids" [] {
  job list
  | where type == frozen
  | each {|j| {value: ($j.id | into string) description: ($j.description? | default "")} }
}

# Wrapper that shadows the builtin only to attach the completer; it forwards to
# the real command via the alias above.
def "job unfreeze" [id?: int@"nu-complete job ids"] {
  if $id == null { job-unfreeze-builtin } else { job-unfreeze-builtin $id }
}
