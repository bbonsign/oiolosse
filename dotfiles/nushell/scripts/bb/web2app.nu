
# Create a desktop launcher for a web app
export def add [
  app_name: string
  app_url: string
  icon_png_url: string = "" # Icon url must be a PNG, e.g. at https://dashboardicons.com"
] {
  # if [ "$#" -ne 3 ]; then
  #   echo "Usage: web2app <AppName> <AppURL> <IconURL> (IconURL must be in PNG -- use https://dashboardicons.com)"
  #   return 1
  # fi

  let icon_dir = $"($env.HOME)/.local/share/icons"
  let desktop_file_path = $"($env.HOME)/.local/share/applications/($app_name).desktop"
  let icon_path = [ $icon_dir $"($app_name).png" ] | path join

  # ^mkdir -p "$icon_dir"

  if ($icon_png_url | is-not-empty) {
    curl -L --output $icon_path $icon_png_url
  }

  let desktop_file = $'
[Desktop Entry]
Version=1.0
Name=($app_name)
Comment=($app_name)
Exec=vivaldi --profile-directory=Default --app-id=($app_name) --app=($app_url) --name=($app_name) --class=($app_name)
Terminal=false
Type=Application
Icon=($icon_path)
StartupNotify=true
'

  $desktop_file | save --force  $desktop_file_path

  chmod +x $desktop_file_path
}

export def "remove" [
  app_name: string
] {
  # if [ "$#" -ne 1 ]; then
  #   echo "Usage: web2app-remove <AppName>"
  #   return 1
  # fi

  let icon_dir = $"($env.HOME)/.local/share/icons"
  let desktop_file_path = $"($env.HOME)/.local/share/applications/($app_name).desktop"
  let icon_path = [ $icon_dir $app_name ".png" ] | path join

  rm $desktop_file_path
  rm $icon_path
}
