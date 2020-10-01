THEME_DELIMITER="%{$fg_bold[blue]%}›%{$reset_color%}%{$fg_bold[red]%}›%{$reset_color%}%{$fg_bold[green]%}›%{$reset_color%}%{$fg_bold[yellow]%}›%{$reset_color%}"

PROMPT='
%(?, ,%{$fg[red]%}FAIL: $?
%{$reset_color%})
%{$fg_bold[blue]%}$(pwd_last_two_segments)%{$reset_color%} $THEME_DELIMITER '

RPROMPT='%{$fg_bold[blue]%}[%*]%{$reset_color%}'
