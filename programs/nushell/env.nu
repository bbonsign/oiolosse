let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | $"value(char tab)description(char newline)" + $in
    | from tsv --flexible --no-infer
}

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

# This completer will use carapace by default
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace completions are incorrect for nu
        # nu => $fish_completer
        # fish completes commits and branch names in a nicer way
        # git => $fish_completer
        # carapace doesn't have completions for asdf
        asdf => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
}

# Set up carapace: https://carapace-sh.github.io/carapace-bin/setup.html#nushell
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
# mkdir ~/.cache/carapace
# carapace _carapace nushell | save --force ~/.cache/carapace/init.nu


$env.PATH = ($env.PATH | split row (char esep) 
    | append ($env.HOME | path join .nix-profile bin)
    | append '/etc/profiles/per-user/$env.USER/bin'
    | append '/run/current-system/sw/bin'
    | append '/nix/var/nix/profiles/default/bin'
    | append ($env.HOME | path join .local bin)
    | uniq)

$env.MANPAGER             = 'nvim +Man!'
$env.NIXPKGS_ALLOW_UNFREE = 1

