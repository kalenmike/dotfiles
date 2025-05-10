zstyle :compinstall filename '/home/ace/.zshrc'
zstyle ':completion:*' insert-tab false
# Enable case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
autoload -Uz compinit && compinit

#setopt MENU_COMPLETE

# Add support for LS_COLORS
export LS_COLORS="$(vivid generate ayu)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
export COLORTERM=truecolor

# Add keybindings for fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh

# Add zoxide
# eval "$(zoxide init zsh)"

export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

ZSH=~/.config/zsh
ZSH_CACHE_DIR="$ZSH/cache"
VIRTUAL_ENV_DISABLE_PROMPT=1

zsh_theme="zipper"

plugins=(
  history
  git
  ultralytics
  zsh-syntax-highlighting
  kubectl
  processes
  nvm
)

# Load plugins
for i in "${plugins[@]}"; 
    do source "$ZSH/plugins/$i.zsh-plugin"; 
done

# Load theme
source "$ZSH/themes/$zsh_theme.zsh-theme"

# Custom Aliases
# --------------------------------------------------------------------
alias ll='ls -lhF --color=always --group-directories-first | awk "{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\"\\033[0;0m%0o \\033[0;0m\",k);print}"'
alias ls="ls -p --group-directories-first --color=always"
alias c="clear && echo -ne \"\\033c\""
alias python="python3" # Allow scripts to run python2 [system has python3]
alias dupterm='nohup kitty >&/dev/null &' # Duplicate Terminal with Working Directory
alias ducks="du -cks * | sort -rn | head" # Get 10 biggest files/folders
alias ra="ranger"
alias tree='find . | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"'
alias chat="/home/ace/Projects/playground/chatgpt-cli/chat"
alias v=nvim
alias f=fuzzy_dirs
alias ff=fuzzy_files
alias bat=batcat
alias bart="export BARTIB_FILE='/home/ace/Projects/activities.bartib' && bartib"
alias ssh-add="ssh_add_overwrite"
alias s="kitty +kitten ssh kalen@ssh.ultralytics.com"
alias rbi="/home/ace/Projects/scripts/remove-bg-image.sh && /home/ace/Projects/scripts/launch/launch-bgimage.sh now"
alias ch=cheat_sheet
alias t="tmux_attach"
alias m="math"

# Custom Functions
# --------------------------------------------------------------------
function math(){
    set -o noglob
    echo $(( $@ ))
    set +o noglob
}


function restart-jobs(){
    PREFIX=$1
    kubectl get jobs --field-selector=status.successful=0 -o custom-columns=":metadata.name" | grep "^${PREFIX}" | awk '{print $1}' | xargs -I {} sh -c "kubectl get job {} -o json | jq 'del(.spec.selector)' |   jq 'del(.spec.template.metadata.labels)' | kubectl replace --force -f - >/dev/null; echo Restarted: {}"
}

function kube-connect() {
    # Connect to pod by id
    kubectl exec -it $1 -c app -- /bin/bash
}

function fuzzy_dirs(){
    local dir
    dir="$(find ~ -type d \( -name node_modules -o -name venv -o -name Trash \) -prune -o -type d | fzf --height 10 --query=$1)"
    if [ -n "$dir" ];then
        cd $dir
        echo Directory: $dir
    fi
}

function fuzzy_files(){
    local file
    file="$(find ~ -type d \( -name node_modules -o -name venv -o -name Trash \) -prune -o -type f | fzf --preview 'batcat --color=always {}' --query="$1")"
    if [ -n "$file" ];then
        cd $(dirname "$file")
        nvim $file
    fi
}

function pysrc() {
    if [ -d "venv" ]; then
        source venv/bin/activate
    else
        echo 'Virtual environment folder not found in the current directory.'
        echo 'Do you want to create a new venv? (y/n): '
        read choice
        if [ "$choice" = "y" ]; then
            python -m venv venv
            source venv/bin/activate
            echo 'Virtual environment created and activated.'
        else
            echo 'Virtual environment not created.'
        fi
    fi
}

function ssh_add_overwrite(){
    echo "THIS IS THE NEW FUNCTION"
    # Start ssh-agent if not running
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        echo -n "Starting SSH Agent: "
        eval "$(ssh-agent)"
    fi
    /usr/bin/ssh-add "$@"
    if [ $? -eq 0 ]; then
        polybar-msg action ssh hook 0 > /dev/null 2>&1
    fi
}

function cheat_sheet(){
    curl -sS https://cht.sh/$1 | less -R
}

function tmux_attach(){
    if ! tmux attach; then
        echo "Starting new tmux session..."
        tmux new-session
    fi
}

# Fix navigation
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

