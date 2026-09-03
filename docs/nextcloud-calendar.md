---
title: "Nextcloud Calendar on mithlond"
document_type: "runbook"
status: "active"
created_at: "2026-09-02"
updated_at: "2026-09-02"
source_thread: "https://ampcode.com/threads/T-01a0609a-f0a8-7264-89fa-6c198de0e41b"
request_context: >-
  Operate the private family calendar service without exposing it outside the
  tailnet or placing credentials in the Nix store.
scope:
  - "Nextcloud Calendar access, setup, backup, restore, and upgrades on mithlond"
decisions:
  - "Named Tailscale Services give Nextcloud and Mealie separate MagicDNS names on HTTPS port 443."
  - "Tailscale Serve terminates HTTPS and proxies each service to its loopback-only backend."
  - "Nextcloud uses local PostgreSQL and Redis and installs Calendar from its matching Nix package set."
handoff: >-
  Complete the documented tailnet service, tag, policy, and approval setup; activate
  the NixOS configuration; then retrieve and store the generated initial administrator
  password. Never skip Nextcloud major versions during upgrades.
tags:
  - "nextcloud"
  - "calendar"
  - "tailscale"
---

# Nextcloud Calendar on mithlond

## Architecture and access

```text
Tailnet client
  -> https://nextcloud.duckbill-wahoo.ts.net/ (svc:nextcloud, TLS on 443)
  -> mithlond Tailscale Service host
  -> http://127.0.0.1:8080 (nginx and PHP-FPM)
  -> local PostgreSQL + Redis Unix socket

Tailnet client
  -> https://mealie.duckbill-wahoo.ts.net/ (svc:mealie, TLS on 443)
  -> mithlond Tailscale Service host
  -> http://127.0.0.1:9000 (Mealie)
```

The endpoints are named Tailscale Services using Serve, not Funnel. The NixOS
systemd units configure and advertise them non-interactively whenever the host
starts. Both application backends listen only on loopback, and no application
port is opened in the host firewall, so neither service is reachable from the
LAN or a router-forwarded public port.

Every client must be logged into the tailnet and granted access to the named
services. MagicDNS and Tailscale HTTPS certificates must be enabled. Keep
Tailscale running while web and CalDAV clients use the service.

## One-time tailnet setup (manual)

Tailscale Services are tailnet control-plane resources, so NixOS cannot create
or approve them. Complete these steps as a tailnet Owner, Admin, or Network
admin before activating this configuration:

1. In **Services**, define `nextcloud` and `mealie`. Give each service the
   advertised endpoint `tcp:443`.
2. In the Tailscale **Access controls** page, define a tag that `mithlond` may
   use and grant the intended users access to SSH and both services. Merge the
   following entries into the existing policy rather than replacing it, and
   narrow `autogroup:member` if only selected family members should have access:

   ```json
   "tagOwners": {
     "tag:server": ["autogroup:admin"]
   },
   "grants": [
     {
       "src": ["autogroup:member"],
       "dst": ["tag:server"],
       "ip": ["22"]
     },
     {
       "src": ["autogroup:member"],
       "dst": ["svc:nextcloud", "svc:mealie"],
       "ip": ["443"]
     }
   ]
   ```

   Preserve any existing rules that provide access to other resources. Tagging
   changes the node from a user identity to a tag identity, so ensure the SSH
   grant is effective before ending the current administrative session.

3. In **Machines**, assign `tag:server` to `mithlond`. Tailscale requires a
   tag-based identity for every Service host.
4. Activate the NixOS configuration. The systemd units run these equivalent
   non-interactive commands; do not run them manually:

   ```console
   tailscale serve --service=svc:nextcloud --yes --https=443 http://127.0.0.1:8080
   tailscale serve --service=svc:mealie --yes --https=443 http://127.0.0.1:9000
   ```

5. Return to **Services**, open each service, and approve the pending
   `mithlond` advertisement. This approval persists across service and host
   restarts. Alternatively, configure `autoApprovers.services` for both service
   names and `tag:server` before activation.

Clients running Tailscale 1.94 or newer discover Service routes automatically.
On an older Linux client, manually enable them once with
`sudo tailscale set --accept-routes`.

## Initial administrator password

Before the first Nextcloud setup, `nextcloud-admin-password.service` generates
the initial administrator password at
`/var/lib/nextcloud-secrets/admin-password`. It is read through a systemd
credential and is not part of the Nix store or repository. After activation,
retrieve it on `mithlond`:

```console
sudo cat /var/lib/nextcloud-secrets/admin-password
```

Store it in the family password manager and do not commit the value. Generation
is idempotent and never replaces a non-empty password file. Local PostgreSQL
authenticates over its Unix socket, so no database password is needed. The
password file is only used when `nextcloud-setup.service` creates a new
instance; changing it later does not change the existing admin password.

Confirm the server is connected to Tailscale:

```console
tailscale status
```

If MagicDNS or HTTPS certificates are not yet enabled, enable them in the
Tailscale admin console before starting the Serve units.

## First-time Nextcloud setup

After an approved NixOS activation (activation is intentionally outside this
repository change), check setup and proxy status:

```console
systemctl status nextcloud-setup nginx tailscale-serve-nextcloud
sudo journalctl -u nextcloud-setup -u tailscale-serve-nextcloud -b
tailscale serve status
nextcloud-occ status
nextcloud-occ app:list | sed -n '/Enabled:/,/Disabled:/p'
```

Open `https://nextcloud.duckbill-wahoo.ts.net/` from a tailnet client and sign in
as `admin` with the generated password. Change the admin password after storing
it safely, set the admin email if mail is later configured, and verify Calendar
appears in the app menu. Calendar is declaratively installed and enabled; the
Nextcloud app store is disabled so it cannot drift from the Nix package.

Mealie remains available separately at
`https://mealie.duckbill-wahoo.ts.net/`.

Create a separate account for every family member under **Administration
settings -> Users**. In Calendar, create a calendar such as **Family**, use its
share menu to add those users, and grant edit permission only where wanted.
Avoid sharing the admin account.

## CalDAV clients

Use the discovery URL:

```text
https://nextcloud.duckbill-wahoo.ts.net/remote.php/dav
```

The direct per-user collection is:

```text
https://nextcloud.duckbill-wahoo.ts.net/remote.php/dav/calendars/<USERNAME>/
```

Create an app password in **Personal settings -> Security -> Devices &
sessions** for each device instead of storing the account password in a client.

- **iOS/iPadOS:** connect Tailscale, then use **Settings -> Apps -> Calendar ->
  Calendar Accounts -> Add Account -> Other -> Add CalDAV Account**. Enter the
  full MagicDNS hostname, Nextcloud username, and app password. If discovery
  fails, use the full `/remote.php/dav` URL in an advanced/manual field.
- **Android:** connect Tailscale and add the account in DAVx5 using **Login with
  URL and user name**. Use the discovery URL, username, and app password, then
  select the calendars to sync. Exempt Tailscale and DAVx5 from aggressive
  battery restrictions if background sync is unreliable.

External web-calendar subscriptions are fetched by the server, not the phone.
`mithlond` therefore needs outbound access to a subscription's public URL.
Refresh timing is controlled by Nextcloud background jobs and is not immediate.
Treat credentials embedded in subscription URLs as secrets. A remote calendar
provider cannot subscribe back to a private Nextcloud URL unless it is also on
the tailnet; exporting a public ICS link would defeat this deployment's privacy
model.

## Backup and restore

No automated backup service exists in this repository. Before relying on the
calendar, arrange encrypted backups outside `mithlond`. A consistent backup
must contain all of these from the same maintenance window:

- a PostgreSQL dump of the `nextcloud` database;
- `/var/lib/nextcloud`, including config and data;
- `/var/lib/nextcloud-secrets/admin-password` (or a verified password-manager
  copy); and
- this flake revision and `flake.lock`, which identify the server and app
  versions.

Example maintenance-window capture (choose a protected backup destination):

```console
sudo nextcloud-occ maintenance:mode --on
sudo -u postgres pg_dump --format=custom nextcloud > nextcloud.pgdump
sudo tar --xattrs --acls -C / -cpf nextcloud-state.tar var/lib/nextcloud var/lib/nextcloud-secrets
sudo nextcloud-occ maintenance:mode --off
```

Ensure maintenance mode is turned off even if a backup command fails. Test
restores periodically on an isolated machine. To restore: stop nginx, PHP-FPM,
Nextcloud jobs, and PostgreSQL; restore the state directory with ownership and
permissions; recreate/restore the PostgreSQL database; restore the runtime
secret; rebuild the recorded NixOS configuration; run `nextcloud-occ upgrade`;
then start services and verify `nextcloud-occ status`. Redis is a cache and is
not backed up.

## Upgrades

The module intentionally pins `pkgs.nextcloud34`; the Calendar package is taken
from `config.services.nextcloud.package.packages.apps`, guaranteeing a matching
app release. Upgrade deliberately rather than silently following a new default:

1. Read the Nextcloud and NixOS release notes and verify Calendar compatibility.
2. Take and test a backup as above.
3. Update the pin to the next major package and update inputs only if intended.
4. Run `nix fmt`, `nix flake check`, and build
   `.#nixosConfigurations.mithlond.config.system.build.toplevel`.
5. During an approved maintenance window, activate that one-major upgrade and
   wait for `nextcloud-setup.service`/`nextcloud-occ upgrade` to finish.
6. Check `nextcloud-occ status`, `nextcloud-occ app:list`, logs, web login, and a
   CalDAV sync before considering another major.

Nextcloud does not support skipping major versions. For example, upgrade 34 to
35 and activate/verify it before 35 to 36. Never jump directly from 34 to 36.

## Troubleshooting

```console
systemctl status nextcloud-admin-password nextcloud-setup phpfpm-nextcloud nginx postgresql redis-nextcloud tailscale-serve-nextcloud mealie tailscale-serve-mealie
journalctl -u nextcloud-admin-password -u nextcloud-setup -u phpfpm-nextcloud -u nginx -u tailscale-serve-nextcloud -b
tailscale status
tailscale serve status
tailscale serve get-config --all
tailscale status --json | jq '.Self.CapMap."service-host"'
ss -lntp | grep -E '(127\.0\.0\.1:8080|127\.0\.0\.1:9000)'
curl -I -H 'Host: nextcloud.duckbill-wahoo.ts.net' http://127.0.0.1:8080/status.php
nextcloud-occ status
nextcloud-occ app:list
nextcloud-occ config:system:get trusted_domains
sudo -u postgres psql -d nextcloud -c 'select 1;'
```

Expected backend listeners are nginx on `127.0.0.1:8080` and Mealie on
`127.0.0.1:9000`; neither may listen on all interfaces. Both named services
should appear in the Serve configuration and as connected in the Tailscale
**Services** page. If a service URL does not connect, check that `mithlond` has
`tag:server`, its advertisement is approved, and the client has a grant to the
service on port 443. An "untrusted domain" error means the client did not use
the configured Nextcloud MagicDNS name.
