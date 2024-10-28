#!/usr/bin/env bash

datetime=$(date "+%a %F %H:%M")
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')
battery=$(cat /sys/class/power_supply/BAT0/capacity)

echo "BAT: $(battery)% | VOL: ${volume}% | ${datetime}"
