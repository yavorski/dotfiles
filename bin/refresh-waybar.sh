#!/usr/bin/env bash

# pacman update
pkill -RTMIN+8 waybar

# disk updates - will not work - the built-in modules supports signals only on click
pkill -RTMIN+12 waybar
pkill -RTMIN+16 waybar
