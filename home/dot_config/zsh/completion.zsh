# === Completions ===
# Consolidated from all modules for easier management

# === bun ===
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# === terraform ===
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/Cellar/tfenv/3.0.0/versions/1.4.6/terraform terraform

# === git worktree ===
# Completion function for gwt-new
_gwt-new() {
  local -a branches
  # Get all branch names (local and remote), strip prefixes
  branches=(${(f)"$(git branch -a 2>/dev/null | sed 's/^[* ]*//; s/^remotes\/[^\/]*\///' | sort -u)"})
  _describe 'branch' branches
}

compdef _gwt-new gwt-new
