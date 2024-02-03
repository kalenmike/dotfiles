autoload -U colors && colors

primary=%{$fg[yellow]%}
secondary=%{$fg[grey]%}

# Add a new line to top of prompt excluding first one.
precmd() {
    clear
    precmd() {
        local last_command=$(fc -ln -1 | tr -d '\n')
        if [[ "$last_command" != "c" ]];then
            # Add a new line as the last command was not clear
            echo
        fi
    }
}

custom_git_info() {
    local dirty=$(parse_git_dirty)
    local git_branch=$(git_current_branch)

    if [ -n "$git_branch" ]; then
        echo "$secondary─(%f%{$fg[magenta]%}$dirty$git_branch$secondary)%f"
    fi
}

is_venv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "%{$fg[blue]%}%f"
    fi
}

active_jobs(){
    local job_count=$(jobs -p | wc -l | xargs)
    (( job_count > 0 )) && echo "%f  $job_count"
}

# Allow for functions in the prompt
setopt prompt_subst

# Load required modules
autoload -U add-zsh-hook

# Define the prompt
PROMPT="$secondary┌──${debian_chroot:+($debian_chroot)}[$primary%1~$secondary]\$(custom_git_info)\$(active_jobs) 
$secondary└─\$(is_venv)$primary> %f"

