# This is used to make tmux look nice and pretty

# Tmux Plugin Manager
# Uses https://github.com/tmux-plugins/tpm
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'jimeh/tmux-themepack'

# Theme
set -g @themepack 'powerline/double/orange'

# Other defaults
# Fixes the issue with the colors in tmux and vim
set -g default-terminal "screen-256color"

# Allows for mouse input in tmux
set -g mouse on

# vi like curser movement in copy mode
set-window-option -g mode-keys vi

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run -b '~/.tmux/plugins/tpm/tpm'
