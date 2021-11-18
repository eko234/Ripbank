#!/bin/bash

sn1=xyft
tmux new-session -s "$sn1" -n api -d
tmux send-keys -t api 'cd ./b' C-m
tmux send-keys -t api "find | entr -r -s 'sleep .5 && rake run'" C-m

tmux new-window -t "$sn1:1" -n app -d
tmux send-keys -t app 'cd ./f/app' C-m
tmux send-keys -t app 'npm start' C-m

tmux select-window -t "$sn1:1"

sn2=xyft2
tmux new-session -s "$sn2"  -n api -d
tmux send-keys -t api 'cd ./b' C-m
tmux send-keys -t api 'kak TODO' C-m

tmux new-window -t "$sn2:1" -n app -d
tmux send-keys -t app 'cd ./f/app/src' C-m
tmux send-keys -t app 'kak TODO' C-m

tmux select-window -t "$sn2:1"
tmux -2 attach-session -t "$sn2"

