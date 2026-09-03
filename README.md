# README

## Remote deployment

Telperion can build the `mithlond` configuration locally, copy the closure to
Mithlond over Tailscale, and activate it there:

```console
mise run deploy
```

The task connects to `bbonsign@mithlond`, so Tailscale MagicDNS and SSH access
must be working. It prompts for Mithlond's `sudo` password during activation.
To activate temporarily or defer activation until reboot, pass `test` or
`boot` respectively:

```console
mise run deploy test
mise run deploy boot
```

The first remote deployment needs one local bootstrap on Mithlond so its Nix
daemon trusts closures uploaded by `bbonsign`. After pulling this configuration
on Mithlond, run `mise run switch` there once. Subsequent deployments can be
run entirely from Telperion.

## Manual Steps
Small tweaks to be done manually on fresh install:

- In Vivaldi, go to <vivaldi://flags/#ozone-platform-hint> and set this to Auto in order to prefer
Wayland over X11. This way you do not have to change the command line parameters. In particular,
this will cause waybar to show the correct app icon for PWAs installed from Vivaldi.

- May have to enable keyd.service: `sudo systemctl enable --now keyd.service`
- May have to add the appropriate vault to `~/.config/1Password/ssh/agent.toml` in order to use work
  keys stored in 1Password.
- Copy `~/.aws/config` over if needed.
