# Inspired by:
# From: https://morgan.cugerone.com/blog/workarounds-to-git-worktree-using-bare-repository-and-cannot-fetch-remote-branches/

# Examples of call:
# jj-clone git@github.com:name/repo.git <directory_name>
# => Clones to a <directory_name>.repo/default.git.jj directory
def --env jj-clone [
  url: string
  directory_name: string = ""
] {

  let dir_name = if ($directory_name | is-empty) {
    $url | path basename | str replace ".git" ".repo"
  } else {
    $"($directory_name).repo"
  }

  # When in ~ or ~/code and cloning from GitHub, place repo under ~/code/<org>/
  let target_dir = if ($url =~ 'github\.com[:/]([^/]+)/') and (($env.PWD == $env.HOME) or ($env.PWD == ($env.HOME | path join "code"))) {
    let org = ($url | parse --regex 'github\.com[:/](?P<org>[^/]+)/' | get 0.org)
    let org_dir = ($env.HOME | path join "code" $org)
    print $"Creating org directory: ($org_dir)"
    mkdir $org_dir
    $org_dir | path join $dir_name
  } else {
    $dir_name
  }

  print $"Creating repo directory: ($target_dir)"
  mkdir $target_dir

  cd $target_dir
  print $"Cloning into: ($target_dir)/default.git.jj"
  jj git clone $url default.git.jj
  cd default.git.jj
}
