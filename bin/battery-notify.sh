#!/usr/bin/env bash

db="/tmp/battery_notify_state"
status=$(< /sys/class/power_supply/BAT0/status)
capacity=$(< /sys/class/power_supply/BAT0/capacity)

touch "$db"
state=$(< "$db")

# Check for low battery (20%)
if [ "$capacity" -eq 20 ] && [ "$status" = "Discharging" ] && [ "$state" != "Empty" ]; then
  echo "Empty" > "$db"
  notify-send --urgency critical "BATTERY LOW"
fi

# Check for charged battery (80%)
if [ "$capacity" -eq 80 ] && [ "$status" = "Charging" ] && [ "$state" != "Full" ]; then
  echo "Full" > "$db"
  notify-send --urgency critical "BATTERY CHARGED"
fi

# Reset state
if [ "$capacity" -gt 20 ] && [ "$capacity" -lt 80 ]; then
  > "$db"
fi
