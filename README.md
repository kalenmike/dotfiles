# Linux Dotfiles


## Structure

```
dotfiles/              # git repo root
├── common/            # shared configs
│   ├── bashrc
│   ├── vimrc
│   ├── tmux.conf
│   └── config/
├── hosts/             # machine-specific overrides
│   ├── laptop/
│   │   └── tmux.conf.local
│   └── desktop/
│       └── tmux.conf.local
├── install.sh         # your symlink script
└── README.md

```

## Install Workflow

```bash
# For common files
link_all_files ./dotfiles/common $HOME_DIR
link_all_files ./dotfiles/common/.config $CONFIG_DIR

# For host-specific files
HOST_DIR=./dotfiles/hosts/$(hostname)
link_all_files "$HOST_DIR" "$HOME_DIR"
link_all_files "$HOST_DIR/.config" "$CONFIG_DIR"

```

## Host Specific


