# Dotfiles Dependencies

## Required
These must be installed for core configs to work:

| Program       | Purpose                        | Notes                           |
|---------------|--------------------------------|---------------------------------|
| polybar       | Status bar for X11             | Required for launch_polybar.sh  |
| xrandr        | Monitor detection               | Used by polybar script          |
| tmux          | Terminal multiplexer            | Required for tmux.conf          |
| zsh           | Shell                          | Required for .zshrc             |
| git           | Version control                 | Required for dotfiles repo      |
| picom           | Rounded corners, transparency   | Required >= v12      |

## Optional
Nice-to-have utilities:

| Program       | Purpose                        | Notes                           |
|---------------|--------------------------------|---------------------------------|
| fzf           | Fuzzy finder                   | Used in custom shell functions  |
| bat           | Cat with syntax highlighting   | Used in aliases                 |
| htop          | Process viewer                 | Convenience                     |

## Aliases / Functions
Some aliases depend on these tools:

- `lg` → lazygit  
- `ll` → `ls -lh --color=auto` (requires `ls` with color support)  
- `bcpu` → custom function, requires `bc`  


Jet Brains Font
