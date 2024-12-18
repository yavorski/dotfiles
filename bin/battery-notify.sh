#!/usr/bin/env bash

status=$(< /sys/class/power_supply/BAT0/status)
capacity=$(< /sys/class/power_supply/BAT0/capacity)

if [ "$status" = "Discharging" ] && [ "$capacity" -eq 20 ]; then
  notify-send --urgency critical "BATTERY LOW"
fi

if [ "$status" = "Charging" ] && [ "$capacity" -eq 80 ]; then
  notify-send --urgency critical "BATTERY CHARGED"
fi
