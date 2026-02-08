# Set up carapace: https://carapace-sh.github.io/carapace-bin/setup.html#nushell
$env.CARAPACE_BRIDGES = 'fish,zsh,bash,inshellisense' # optional

$env.PATH = (
  $env.PATH | split row (char esep)
  | append ($env.HOME | path join .nix-profile bin)
  | append '/etc/profiles/per-user/$env.USER/bin'
  | append '/run/current-system/sw/bin'
  | append '/nix/var/nix/profiles/default/bin'
  | prepend ($env.HOME | path join .local bin)
  | prepend ($env.HOME | path join .mix escripts)
  | prepend ($env.HOME | path join .bun bin)
  | uniq
)

# Echo chosen directory when using zoxide
$env._ZO_ECHO = "1";
#
# https://github.com/andyl/plug_editor_launch
$env.PLUG_EDITOR = "plug-edit:__FILE__:__LINE__:neovim:kitty"

$env.ERL_AFLAGS = "-kernel shell_history enabled";
$env.MANPAGER = 'nvim +Man!'
$env.MANWIDTH = 150 # from vim help, prevents bad line wrapping
$env.NIXPKGS_ALLOW_UNFREE = 1

# $env.PROMPT_INDICATOR = "〉"
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
# $env.PROMPT_MULTILINE_INDICATOR = "::: "

$env.XDG_CONFIG_HOME = if ($env.XDG_CONFIG_HOME? | is-empty) { [$env.HOME ".config"] | path join } else { $env.XDG_CONFIG_HOME }
# https://github.com/blindFS/topiary-nushell
$env.TOPIARY_CONFIG_FILE = ($env.XDG_CONFIG_HOME | path join topiary languages.ncl)
$env.TOPIARY_LANGUAGE_DIR = ($env.XDG_CONFIG_HOME | path join topiary languages)
