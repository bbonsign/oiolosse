#!/usr/bin/env nu

swaymsg $"[con_mark=(swaymsg -t get_marks | from json | to text | fuzzel --dmenu --prompt 'Goto mark:')]" focus
