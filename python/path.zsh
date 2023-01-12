pyenv() {
  eval "$(command pyenv init -)"
  eval "$(command pyenv virtualenv-init -)"
  export PATH=$(pyenv root)/shims:$PATH
  pyenv "$@"
}

# # Initialize pyenv and its virtualenv plugin.
# if command -v pyenv &> /dev/null; then
#     eval "$(pyenv init -)"
#     eval "$(pyenv virtualenv-init -)"
#     export PATH=$(pyenv root)/shims:$PATH
# fi
