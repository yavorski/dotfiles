#!/usr/bin/env bash

# $(sleep 5; systemctl suspend) & exec hyprlock --immediate
# $(sleep 5; systemctl hibernate) & exec hyprlock --immediate

$(sleep 5; systemctl suspend-then-hibernate) & exec hyprlock --immediate
