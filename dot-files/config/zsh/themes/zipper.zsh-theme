autoload -U colors && colors

primary=%{$fg[yellow]%}
secondary=%{$fg[grey]%}

# Add a new line to top of prompt excluding first one.
precmd() {
    precmd() {
        if [[ $(fc -ln -1) != "c" ]];then
            echo 
        fi
    }
}

add_newline_after_command() {
    if [[ -n "$PS1" ]] && [[ "$HISTCMD" != "$HISTLAST" ]]; then
        echo hello
    fi
}

dir_summary() {
    return
    local FILES=$(ls | grep -v / | wc -l)
    local FOLDERS=$(ls | grep / | wc -l)
    local HIDDEN=$(ls -A | grep "^\." | wc -l)
    local HIDDEN_PROMPT=""
    if [ "$HIDDEN" != "0" ]; then
        HIDDEN_PROMPT=" 󰘓 $HIDDEN"
    fi
    echo "$secondary─($primary $FOLDERS  $FILES$HIDDEN_PROMPT$secondary)%f"
}

custom_git_info() {
    local dirty=$(parse_git_dirty)
    local git_branch=$(git_current_branch)

    if [ -n "$git_branch" ]; then
        echo "$secondary─(%f%{$fg[magenta]%}$dirty$git_branch$secondary)%f"
    fi
}

parse_git_branch() {
    local branch=$(git_current_branch)
    [[ -n "$branch" ]] || return 0
    echo "$secondary─(%f%{$fg[magenta]%}$branch$secondary)%f"
}

is_venv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "%{$fg[blue]%}%f"
    fi
}

# Allow for functions in the prompt
setopt prompt_subst

# Load required modules
autoload -U add-zsh-hook
PROMPT="$secondary┌──${debian_chroot:+($debian_chroot)}[$primary%1~$secondary]\$(dir_summary)\$(custom_git_info)%(1j.%j.) 
$secondary└─\$(is_venv)$primary> %f"
