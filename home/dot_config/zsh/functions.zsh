# === Functions ===

# === git ===
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

# === shell ===
dotfiles() {
  $EDITOR ~/.local/share/dotfiles.code-workspace
}
