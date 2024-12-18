#!/usr/bin/env bash

# $(sleep 2; systemctl suspend) & exec hyprlock --immediate
# $(sleep 2; systemctl hibernate) & exec hyprlock --immediate

$(sleep 2; systemctl suspend-then-hibernate) & exec hyprlock --immediate
