#!/usr/bin/env nu

let CONFIG_DIR = $env.HOME | path join .config
let CONF = $CONFIG_DIR | path join keyd default.conf

mkdir /etc/keyd

sudo cp $CONF /etc/keyd/

sudo /var/home/bbonsign/.nix-profile/bin/keyd reload
