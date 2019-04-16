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

# Binds new panels to their original panel's path
# And makes new windows bind to the home directory
bind c new-window -c "$HOME"
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"

# Sets the title of the window
set-option -g set-titles on
set-option -g set-titles-string "#{session_name} @shiromatty"

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run -b '~/.tmux/plugins/tpm/tpm'
