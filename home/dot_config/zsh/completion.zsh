# === Completions ===
# Consolidated from all modules for easier management

# === bun ===
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# === terraform ===
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/Cellar/tfenv/3.0.0/versions/1.4.6/terraform terraform

