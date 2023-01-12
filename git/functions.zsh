function copy_last_commit_hash() {
    HASH=$(git log -n 1 --pretty=format:"%H")
    echo -n "$HASH" | pbcopy # Use -n to strip trailing newline
    echo "Copied: $HASH"
}

function get_dir_or_repo_root() {
    (git rev-parse --show-toplevel 2>/dev/null) || echo "$PWD"
}
