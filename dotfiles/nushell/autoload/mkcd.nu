# Create directories and cd into the last one
def --env mkcd [...dirs: path] {
  if ($dirs | is-empty) {
    error make {msg: "mkcd requires at least one directory argument"}
  }
  mkdir ...($dirs)
  cd ($dirs | last)
}
