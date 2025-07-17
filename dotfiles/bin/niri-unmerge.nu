#!/usr/bin/env nu
# Merges the currently focused window into the column to the left and converts to a tabbed layout


export def main [] {
  niri msg action toggle-column-tabbed-display
  niri msg action consume-or-expel-window-right
}
