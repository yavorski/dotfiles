#!/usr/bin/env bash

status=$(< /sys/class/power_supply/BAT0/status)
capacity=$(< /sys/class/power_supply/BAT0/capacity)

if [ "$status" = "Discharging" ] && [ "$capacity" -le 20 ]; then
  notify-send --urgency critical "BATTERY LOW"
fi

if [ "$status" = "Charging" ] && [ "$capacity" -ge 80 ]; then
  notify-send --urgency normal "BATTERY CHARGED"
fi
