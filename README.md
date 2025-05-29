# README

## Manual Steps
Small tweaks to be done manually on fresh install:

- In Vivaldi, go to <vivaldi://flags/#ozone-platform-hint> and set this to Auto in order to prefer
Wayland over X11. This way you do not have to change the command line parameters. In particular,
this will cause waybar to show the correct app icon for PWAs installed from Vivaldi.

- May have to enable keyd.service: `sudo systemctl enable --now keyd.service`
- May have to add the appropriate vault to `~/.config/1Password/ssh/agent.toml` in order to use work
  keys stored in 1Password.
- Copy `~/.aws/config` over if needed.

