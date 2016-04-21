#!/bin/sh
[[ $TERM == "tmux" ]] && exit 1


tmux new-session -d -s crazy@home -n 'root' 'su -'
tmux new-window -t crazy@home:2 -n 'emacs' 'emacs -nw'
tmux new-window -t crazy@home:3 -n 'home'

tmux select-window -t crazy@home:3
tmux -2 attach-session -t crazy@home
