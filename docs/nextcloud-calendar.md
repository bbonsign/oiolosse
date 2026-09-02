---
title: "Nextcloud Calendar on mithlond"
document_type: "runbook"
status: "active"
created_at: "2026-09-02"
source_thread: "https://ampcode.com/threads/T-01a0609a-f0a8-7264-89fa-6c198de0e41b"
request_context: >-
  Operate the private family calendar service without exposing it outside the
  tailnet or placing credentials in the Nix store.
scope:
  - "Nextcloud Calendar access, setup, backup, restore, and upgrades on mithlond"
decisions:
  - "Tailscale Serve terminates HTTPS and proxies to loopback-only nginx."
  - "Nextcloud uses local PostgreSQL and Redis and installs Calendar from its matching Nix package set."
handoff: >-
  Provision the documented password file and confirm Tailscale MagicDNS and HTTPS
  before the first activation. Never skip Nextcloud major versions during upgrades.
tags:
  - "nextcloud"
  - "calendar"
  - "tailscale"
---

# Nextcloud Calendar on mithlond

## Architecture and access

```text
Tailnet client
  -> https://<MITHLOND-MAGICDNS-NAME>/ (Tailscale Serve, TLS on 443)
  -> http://127.0.0.1:8080 (nginx and PHP-FPM)
  -> local PostgreSQL + Redis Unix socket
```

`<MITHLOND-MAGICDNS-NAME>` is the full name reported by
`tailscale status --json`, normally `mithlond.<TAILNET-DNS-SUFFIX>.ts.net`.
The endpoint is Tailscale Serve, not Funnel, and nginx listens only on loopback.
No application port is opened in the host firewall, so the service is not
reachable from the LAN or a router-forwarded public port.

Every client must be logged into the tailnet and permitted to reach `mithlond`
by the tailnet ACL/grants policy. MagicDNS and Tailscale HTTPS certificates must
be enabled for the tailnet. Keep Tailscale running while web and CalDAV clients
use the service.

## Before first activation

The only provisioned credential is the initial Nextcloud administrator
password. It is read at runtime through a systemd credential and is not part of
the Nix store or repository. On `mithlond`, create it before the first
activation:

```console
sudo install -d -m 0700 -o root -g root /var/lib/nextcloud-secrets
sudo openssl rand -base64 36 -out /var/lib/nextcloud-secrets/admin-password
sudo chmod 0600 /var/lib/nextcloud-secrets/admin-password
```

Store a copy in the family password manager. Do not commit the value. Local
PostgreSQL authenticates over its Unix socket, so no database password is
needed. The password file is only used when `nextcloud-setup.service` creates a
new instance; changing it later does not change the existing admin password.

Confirm the server is already connected to Tailscale and find its URL:

```console
tailscale status
tailscale status --json | jq -r '.Self.DNSName'
```

The first `tailscale serve` invocation may ask a tailnet administrator to enable
MagicDNS/HTTPS. Complete that prerequisite in the Tailscale admin console, then
restart `tailscale-serve-nextcloud.service` if necessary.

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

Open `https://<MITHLOND-MAGICDNS-NAME>/` from a tailnet client and sign in as
`admin` with the provisioned password. Change the admin password after storing
it safely, set the admin email if mail is later configured, and verify Calendar
appears in the app menu. Calendar is declaratively installed and enabled;
the Nextcloud app store is disabled so it cannot drift from the Nix package.

Create a separate account for every family member under **Administration
settings -> Users**. In Calendar, create a calendar such as **Family**, use its
share menu to add those users, and grant edit permission only where wanted.
Avoid sharing the admin account.

## CalDAV clients

Use the discovery URL:

```text
https://<MITHLOND-MAGICDNS-NAME>/remote.php/dav
```

The direct per-user collection is:

```text
https://<MITHLOND-MAGICDNS-NAME>/remote.php/dav/calendars/<USERNAME>/
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
systemctl status nextcloud-setup phpfpm-nextcloud nginx postgresql redis-nextcloud tailscale-serve-nextcloud
journalctl -u nextcloud-setup -u phpfpm-nextcloud -u nginx -u tailscale-serve-nextcloud -b
tailscale status
tailscale serve status
ss -lntp | grep -E '(:443|127\.0\.0\.1:8080)'
curl -I -H 'Host: mithlond.<TAILNET-DNS-SUFFIX>.ts.net' http://127.0.0.1:8080/status.php
nextcloud-occ status
nextcloud-occ app:list
nextcloud-occ config:system:get trusted_domains
sudo -u postgres psql -d nextcloud -c 'select 1;'
```

Expected listeners are Tailscale-managed HTTPS on port 443 and nginx on
`127.0.0.1:8080`; nginx must not listen on `0.0.0.0:8080` or `[::]:8080`. An
"untrusted domain" error means the client did not use
`mithlond.<TAILNET-DNS-SUFFIX>.ts.net`; inspect the actual request hostname and
the configured trusted domains. Certificate or Serve errors usually mean the
node is logged out, MagicDNS/HTTPS is disabled, or tailnet policy denies access.
