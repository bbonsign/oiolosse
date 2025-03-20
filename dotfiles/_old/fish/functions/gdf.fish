function gdf
    set preview "git diff $argv --color=always -- {-1} | delta"
    git diff $argv --name-only | fzf -m --ansi --preview $preview
end
