#!/usr/bin/env bash
# original source: https://gitlab.com/Nmoleo/i3-volume-brightness-indicator

max_volume=100
notification_timeout=1000

# Uses regex to get volume from pactl
function get_volume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

# Uses regex to get mute status from pactl
function get_mute {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(\w+)' | sed 's/ja/yes/g'
}

# Returns an icon depending on the volume
function get_volume_icon {
    local volume=$(get_volume)
    local mute=$(get_mute)
    if [[ $volume -eq 0 || $mute == "yes" ]] ; then
        echo "" # 
    elif [[ $volume -lt 50 ]]; then
        echo ""
    else
        echo ""
    fi
}

# Displays a volume notification using notify-send
function show_volume_notif {
    volume_icon=$(get_volume_icon)
    volume=$(get_volume)
    notify-send -t $notification_timeout -h string:x-dunst-stack-tag:volume_notif -h int:value:$volume "Volume" "$volume_icon $volume%"
}

# Process the input
action=$1
volume_step=${2:-"2"}
case "$action" in
    up)
    	pactl set-sink-mute @DEFAULT_SINK@ 0
	volume=$(get_volume)
    	if (( $volume + $volume_step > $max_volume )); then
            pactl set-sink-volume @DEFAULT_SINK@ "${max_volume}%"
        else
            pactl set-sink-volume @DEFAULT_SINK@ "+${volume_step}%"
        fi
        show_volume_notif
        ;;

    down)
        pactl set-sink-volume @DEFAULT_SINK@ "-${volume_step}%"
        volume=$(get_volume)
        if (( $volume <= 0 )); then
            pactl set-sink-mute @DEFAULT_SINK@ 1
        fi
        show_volume_notif
        ;;

    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        show_volume_notif
        ;;
esac
