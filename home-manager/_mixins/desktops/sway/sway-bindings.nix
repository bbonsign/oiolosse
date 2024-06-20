{ config }:

let
  mod = "Mod4";
  left = "h";
  down = "j";
  up = "k";
  right = "l";
in
{

  #"${mod}+t" = ''[class="scratchterm"] scratchpad show, move position center'';
  #"${mod}+b" = ''[class="scratchbrowser"] scratchpad show, move position center '';

  "${mod}+Return" = "exec ${g-alacritty}/bin/alacritty";
  "${mod}+Shift+q" = "kill";
  "${mod}+d" = "exec ${config.wayland.windowManager.sway.config.menu}";
  "${mod}+c" = "split h";
  #"${mod}+v" = "split v";
  #"${mod}+f" = "fullscreen toggle";

  #"${mod}+s" = "layout stacking";
  "${mod}+t" = "layout tabbed";
  #"${mod}+e" = "layout toggle split";

  #"${mod}+Shift+space" = "floating toggle";
  #"${mod}+space" = "focus mode_toggle";

  #"${mod}+a" = "focus parent";

  "${mod}+Shift+minus" = "move scratchpad";
  "${mod}+minus" = "scratchpad show";

  "${mod}+Shift+r" = "reload";
  "${mod}+Shift+e" = ''
    exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'
  '';

  "${mod}+r" = "mode resize";

  "${mod}+${left}" = "focus left";
  "${mod}+${down}" = "focus down";
  "${mod}+${up}" = "focus up";
  "${mod}+${right}" = "focus right";
  "${mod}+Ctrl+${left}" = "move workspace to output left";
  "${mod}+Ctrl+${down}" = "move workspace to output down";
  "${mod}+Ctrl+${up}" = "move workspace to output up";
  "${mod}+Ctrl+${right}" = "move workspace to output right";
  "${mod}+Shift+${left}" = "move left";
  "${mod}+Shift+${down}" = "move down";
  "${mod}+Shift+${up}" = "move up";
  "${mod}+Shift+${right}" = "move right";

  # Note: workspaces can have any name you want, not just numbers.
  "${mod}+1" = "workspace number 1";
  "${mod}+2" = "workspace number 2";
  "${mod}+3" = "workspace number 3";
  "${mod}+4" = "workspace number 4";
  "${mod}+5" = "workspace number 5";
  "${mod}+6" = "workspace number 6";
  "${mod}+7" = "workspace number 7";
  "${mod}+8" = "workspace number 8";
  "${mod}+9" = "workspace number 9";
  "${mod}+0" = "workspace number 10";

  "${mod}+Shift+1" = "move container to workspace number 1";
  "${mod}+Shift+2" = "move container to workspace number 2";
  "${mod}+Shift+3" = "move container to workspace number 3";
  "${mod}+Shift+4" = "move container to workspace number 4";
  "${mod}+Shift+5" = "move container to workspace number 5";
  "${mod}+Shift+6" = "move container to workspace number 6";
  "${mod}+Shift+7" = "move container to workspace number 7";
  "${mod}+Shift+8" = "move container to workspace number 8";
  "${mod}+Shift+9" = "move container to workspace number 9";
  "${mod}+Shift+0" = "move container to workspace number 10";

  Print = ''
    exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp -d)" - | ${wl-clipboard}/bin/wl-copy -t image/png'';
  "Ctrl+Print" = ''
    exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp -d)" - | ${wl-clipboard}/bin/wl-copy -t image/png'';
  XF86AudioMute =
    "exec ${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
  XF86AudioPlay = "exec ${playerctl}/bin/playerctl play";
  XF86AudioPause = "exec ${playerctl}/bin/playerctl pause";
  XF86AudioNext = "exec ${playerctl}/bin/playerctl next";
  XF86AudioPrev = "exec ${playerctl}/bin/playerctl prev";
  XF86AudioRaiseVolume =
    "exec ${pulseaudio}/bin/pactl  set-sink-volume @DEFAULT_SINK@ +5%";
  XF86AudioLowerVolume =
    "exec ${pulseaudio}/bin/pactl  set-sink-volume @DEFAULT_SINK@ -5%";
  XF86MonBrightnessUp = "exec ${xorg.xbacklight} -inc 20";
  XF86MonBrightnessDown = "exec ${xorg.xbacklight} -dec 20";
}
