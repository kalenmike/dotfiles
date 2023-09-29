
zstyle :compinstall filename '/home/ace/.zshrc'
zstyle ':completion:*' insert-tab false
autoload -Uz compinit && compinit

# Add support for LS_COLORS
export LS_COLORS="$(vivid generate ayu)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

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
alias c="clear && echo -e \"\\033c\""
alias python="python3" # Allow scripts to run python2 [system has python3]
alias dupterm='nohup kitty >&/dev/null &' # Duplicate Terminal with Working Directory
alias ducks="du -cks * | sort -rn | head" # Get 10 biggest files/folders
alias ra="ranger"
alias pysrc="if [ -d "venv" ]; then source venv/bin/activate; else echo 'Error: venv folder not found in the current directory.'; fi"
alias tree='find . | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"'
alias chat="/home/ace/Projects/playground/chatgpt-cli/chat"
alias vim=nvim
alias sd=fuzzy_dirs
alias fd=fuzzy_files
alias bat=batcat
# Custom Functions
# --------------------------------------------------------------------
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
    dir="$(find ~ -type d \( -name node_modules -o -name venv -o -name Trash \) -prune -o -type d | fzf --query=$1)"
    if [ -n "$dir" ];then
        cd $dir
    fi
}

function fuzzy_files(){
    local file
    file="$(find ~ -type d \( -name node_modules -o -name venv -o -name Trash \) -prune -o -type f | fzf --preview 'batcat --color=always {}' --query="$1")"
    if [ -n "$file" ];then
        vim $file
    fi
}

# Fix navigation
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

