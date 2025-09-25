function copy_last_commit_hash() {
    HASH=$(git log -n 1 --pretty=format:"%H")
    echo -n "$HASH" | pbcopy # Use -n to strip trailing newline
    echo "Copied: $HASH"
}

function get_dir_or_repo_root() {
    (git rev-parse --show-toplevel 2>/dev/null) || echo "$PWD"
}

# remove a worktree via fzf (shows "path<TAB>branch"; selects by branch)
function gwt-rm() {
  local sel
  sel="$(
    git worktree list --porcelain |
      awk '
        $1=="worktree" { p=$2 }
        $1=="branch"  { sub("refs/heads/","",$2); print p "\t" $2 }
      ' |
      fzf --prompt='remove worktree> ' --with-nth=2
  )" || return

  # take the path (field 1) and remove it
  [ -n "$sel" ] && git worktree remove -- "${sel%%	*}"
}
