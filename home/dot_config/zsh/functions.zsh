# === Functions ===

# === git ===
# create a new worktree with automatic setup
# Usage: gwt-new <branch-name> [base-branch]
# Environment variables:
#   GWT_ROOT: override default worktree location (default: ../<repo>-wt/)
#   GWT_EDITOR: command to open worktree in editor (e.g., "code", "cursor")
function gwt-new() {
  if [[ -z "$1" ]]; then
    echo "Usage: gwt-new <branch-name> [base-branch]"
    return 1
  fi

  local branch_name="$1"
  local base_branch="${2:-main}"

  # Get the root of the current git repo
  local repo_root
  repo_root="$(git rev-parse --show-toplevel)" || return 1

  # Get the repo name
  local repo_name="$(basename "$repo_root")"

  # Determine worktree parent directory
  # Default: sibling directory named <repo>-wt
  local wt_parent="${GWT_ROOT:-$(dirname "$repo_root")/${repo_name}-wt}"

  # Full path for new worktree
  local wt_path="${wt_parent}/${branch_name}"

  # Create parent directory if it doesn't exist
  mkdir -p "$wt_parent"

  echo "Creating worktree at: $wt_path"

  # Create the worktree (will create branch if it doesn't exist)
  if ! git worktree add -b "$branch_name" "$wt_path" "$base_branch" 2>/dev/null; then
    # Branch might already exist, try without -b
    if ! git worktree add "$wt_path" "$branch_name"; then
      echo "Failed to create worktree"
      return 1
    fi
  fi

  # Run project-specific setup if .worktree-setup exists in the main repo
  if [[ -x "$repo_root/.worktree-setup" ]]; then
    echo "Running .worktree-setup..."
    (cd "$wt_path" && "$repo_root/.worktree-setup")
  elif [[ -f "$repo_root/.worktree-setup" ]]; then
    echo "Running .worktree-setup..."
    (cd "$wt_path" && bash "$repo_root/.worktree-setup")
  fi

  # Open in editor if GWT_EDITOR is set
  if [[ -n "$GWT_EDITOR" ]]; then
    echo "Opening in $GWT_EDITOR..."
    $GWT_EDITOR "$wt_path"
  fi

  echo "Worktree created successfully!"
  echo "To navigate: cd $wt_path"
}

# remove a worktree via fzf or by branch name
# Usage: gwt-rm [branch-name]
# If no argument provided, uses fzf to select interactively
function gwt-rm() {
  local sel

  if [[ -n "$1" ]]; then
    # Argument provided - find matching worktree by branch name
    sel="$(
      git worktree list --porcelain |
        awk -v branch="$1" '
          $1=="worktree" { p=$2 }
          $1=="branch"   {
            sub("refs/heads/","",$2)
            if ($2 == branch) {
              print p "\t" $2
              exit
            }
          }
        '
    )"

    if [[ -z "$sel" ]]; then
      echo "Error: No worktree found for branch '$1'"
      return 1
    fi
  else
    # No argument - use fzf for interactive selection
    sel="$(
      git worktree list --porcelain |
        awk '
          $1=="worktree" { p=$2 }
          $1=="branch"  { sub("refs/heads/","",$2); print p "\t" $2 }
        ' |
        fzf --prompt='remove worktree> ' --with-nth=2
    )" || return
  fi

  # take the path (field 1) and remove it
  [ -n "$sel" ] && git worktree remove -- "${sel%%	*}"
}

# list all worktrees with status
function gwt-ls() {
  git worktree list
}

# === agentbox ===
# Switch to agentdev user in sandbox
agentbox() {
  local target_dir="${1:-$(pwd)}"

  case "$target_dir" in
    /Users/Shared/Agentbox*) ;;
    *) target_dir="/Users/Shared/Agentbox" ;;
  esac

  _agentbox_start_permfixer

  # Write target dir for agentdev's .zshrc to read
  echo "$target_dir" > /Users/Shared/Agentbox/.agentbox-target-dir
  chmod 666 /Users/Shared/Agentbox/.agentbox-target-dir

  # Replace shell with agentdev login shell
  exec sudo -u agentdev -i
}

_agentbox_start_permfixer() {
  local pid_file="/tmp/agentbox-permfixer.pid"
  local script="/Users/Shared/Agentbox/agentbox/scripts/permfixer.sh"
  [[ ! -f "$script" ]] && return 0
  if [[ -f "$pid_file" ]] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
    return 0  # Already running
  fi
  nohup "$script" &>/dev/null &
}
