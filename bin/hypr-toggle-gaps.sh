#!/usr/bin/env bash

# get active workspace id
id=$(hyprctl -j activeworkspace | jq ".id")

# set range variable in order to match the workspace (not working by id only)
rid="r[$id-$id]"

# default gaps values - can get them with hyprctl too
gaps_in_default=5 # hyprctl getoption general:gaps_in
gaps_out_default=10 # hyprctl getoption general:gaps_out

# current gaps for active workspace
gaps_in_current=$(hyprctl workspacerules -j | jq --arg rid "$rid" '[.[] | select(.workspaceString | startswith($rid)) | .gapsIn[0]] | .[0]')
gaps_out_current=$(hyprctl workspacerules -j | jq --arg rid "$rid" '[.[] | select(.workspaceString | startswith($rid)) | .gapsOut[0]] | .[0]')

# toggle gaps for the active workspace
if [[ ("$gaps_in_current" == "null" && "$gaps_out_current" == "null") || ("$gaps_in_current" == "$gaps_in_default" && "$gaps_out_current" == "$gaps_out_default") ]]; then
  hyprctl keyword workspace $rid f[1], gapsin:0, gapsout:0
  hyprctl keyword workspace $rid w[tv1], gapsin:0, gapsout:0
else
  hyprctl keyword workspace $rid f[1], gapsin:$gaps_in_default, gapsout:$gaps_out_default
  hyprctl keyword workspace $rid w[tv1], gapsin:$gaps_in_default, gapsout:$gaps_out_default
fi
