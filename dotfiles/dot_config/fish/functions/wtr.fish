function wtr --description 'cd to root of the worktree, assuming to be in a bare repo with worktree names == branch names'
  set branch (git rev-parse --abbrev-ref HEAD);
  cd (git rev-parse --git-dir)/../../../$branch;
end
