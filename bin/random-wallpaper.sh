#!/usr/bin/env bash

if [[ $# -lt 1 ]] || [[ ! -d $1 ]]; then
	echo "Usage:
	$0 <dir containing images>"
	exit 1
fi

# Define the directory
directory=$1

# Define the extensions array
extensions=("png" "jpg" "jpeg" "webp")

# Build the ripgrep glob pattern
rg_pattern=$(IFS=,; echo "${extensions[*]/#/*.}")
rg_pattern="{$rg_pattern}"

# Execute the ripgrep command to find files with the desired extensions
random_image=$(rg --files "$directory" --glob "$rg_pattern" | shuf -n 1)

# Print the result
if [[ -n $random_image ]]; then
  echo "Random image: $random_image"
else
  echo "No image files found in $directory"
  $random_image=/usr/share/hypr/wall2.png
fi

hyprctl hyprpaper preload $random_image
hyprctl hyprpaper wallpaper, $random_image
sleep 1 && hyprctl hyprpaper unload all
