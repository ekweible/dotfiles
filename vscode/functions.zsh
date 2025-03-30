work() {
  local workspace_dir="$HOME/dev/code-workspaces"
  local current_dir_name=$(basename "$(pwd)")
  local workspace_file
  local editor="${1:-$EDITOR}"

  workspace_file=$(find "$workspace_dir" -maxdepth 1 -name "$current_dir_name*.code-workspace" 2>/dev/null | head -n 1)

  if [[ -n "$workspace_file" ]]; then
    "$editor" "$workspace_file"
  else
    "$editor" .
  fi
}
