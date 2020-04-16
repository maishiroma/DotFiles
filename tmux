# This is used to make tmux look nice and pretty
# Remember, to reload configuration: CTRL+B + I

### List of plugins

# Tmux Plugin Manager
# Uses https://github.com/tmux-plugins/tpm
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Tmux Theme
set -g @plugin 'dracula/tmux'

# Other defaults
# Fixes the issue with the colors in tmux and vim
set -g default-terminal "screen-256color"

# Allows for mouse input in tmux
set -g mouse on

# vi like curser movement in copy mode
set-window-option -g mode-keys vi
unbind-key -T copy-mode-vi MouseDragEnd1Pane
bind-key -T copy-mode-vi MouseDown1Pane select-pane\; send-keys -X clear-selection
bind -n MouseDrag1Pane if -Ft= '#{mouse_any_flag}' 'if -Ft= \"#{pane_in_mode}\" \"copy-mode -eM\" \"send-keys -M\"' 'copy-mode -eM'

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
