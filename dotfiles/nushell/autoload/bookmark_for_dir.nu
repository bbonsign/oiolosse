#!/usr/bin/env nu

let bookmark_file_dir = $"($env.HOME)/.config/bookmark_for_dir"
let bookmark_file = $"($bookmark_file_dir)/bookmark.json"

# add bookmark
export def "bm add" [desc: string] {
  _check_and_init_file
  let work_dir = (pwd)
  open $bookmark_file | append [[desc path];[$desc $work_dir]] | collect | save -f $bookmark_file
  echo 'SUCCESS'
}

# list bookmarks
export def --env "bm ls" [] {
  open $bookmark_file 
}

# change dir by num
export def --env "bm cd" [num: int] {
  cd (open $bookmark_file | get path | get $num)
}

# delete bookmark
export def "bm rm" [desc: string@_desc_list] {
  open $bookmark_file | where desc != $desc | collect | save -f $bookmark_file
  open $bookmark_file
}

# manage bookmark, change dir(cd).
export def --env bm [
  desc?: string@_desc_list # if input desc, will change dir.
] {
  if ($desc == null) {
    _check_and_init_file
    open $bookmark_file
  } else {
    cd (open $bookmark_file | where desc == $desc | get path | get 0)
  }
}

def _desc_list [] {
  open $bookmark_file | get desc
}

def _check_and_init_file [] {
  # create dir
  if ($bookmark_file_dir | path exists) == false {
    mkdir $bookmark_file_dir
  }

  if ($bookmark_file | path exists) == false {
    # create file
    touch $bookmark_file
  }
}
