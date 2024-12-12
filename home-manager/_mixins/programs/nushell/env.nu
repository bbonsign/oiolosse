# Set up carapace: https://carapace-sh.github.io/carapace-bin/setup.html#nushell
$env.CARAPACE_BRIDGES = 'fish,zsh,bash,inshellisense' # optional


$env.PATH = ($env.PATH | split row (char esep) 
    | append ($env.HOME | path join .nix-profile bin)
    | append '/etc/profiles/per-user/$env.USER/bin'
    | append '/run/current-system/sw/bin'
    | append '/nix/var/nix/profiles/default/bin'
    | append ($env.HOME | path join .local bin)
    | uniq)

$env.MANPAGER             = 'nvim +Man!'
$env.NIXPKGS_ALLOW_UNFREE = 1

# $env.PROMPT_INDICATOR = "〉"
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
# $env.PROMPT_MULTILINE_INDICATOR = "::: "
