// =============================================================================
//
// Waybar configuration
//
// Configuration reference: https://github.com/Alexays/Waybar/wiki/Configuration
//
// =============================================================================
{
    // -------------------------------------------------------------------------
    // Global configuration
    // -------------------------------------------------------------------------
    "layer": "top",
    "position": "top",
    // If height property would be not present, it'd be calculated dynamically
    "height": 30,
    "modules-left": [
        "sway/workspaces",
        "sway/mode"
    ],
    "modules-center": [
        "sway/window"
    ],
    "modules-right": [
        "network",
        "memory",
        "cpu",
        "disk",
        "tray",
        "clock#date",
        "clock#time",
        "custom/power"
    ],
    // -------------------------------------------------------------------------
    // Modules
    // -------------------------------------------------------------------------
    "clock#time": {
        "interval": 1,
        "format": "{:%H:%M}",
        "tooltip": false
    },
    "clock#date": {
        "interval": 10,
        "format": "  {:%F}", // Icon: calendar-alt
        "tooltip": false
    },
    "cpu": {
        "interval": 5,
        "format": "  {usage}% ({load})", // Icon: microchip
        "states": {
            "warning": 70,
            "critical": 90
        }
    },
    "memory": {
        "interval": 5,
        "format": "  {}%", // Icon: memory
        "states": {
            "warning": 70,
            "critical": 90
        }
    },
    "disk": {
        "interval": 30,
        "format": " {percentage_used}%", // Icon: database
        "path": "/"
    },
    "network": {
        "interval": 5,
        "format-ethernet": ": {bandwidthDownOctets} : {bandwidthUpOctets}", // Icon: ethernet
        "format-disconnected": "⚠  Disconnected",
        "tooltip-format": "{ifname}: {ipaddr}"
    },
    "sway/mode": {
        "format": "<span style=\"italic\">  {}</span>", // Icon: expand-arrows-alt
        "tooltip": false
    },
    "sway/window": {
        "format": "{}",
        "max-length": 50
    },
    "sway/workspaces": {
        "all-outputs": false,
        "disable-scroll": true,
        "format": "{name}"
    },
    "custom/power": {
        "format": "",
        "on-click": "swaynag -t warning -m 'Power Menu Options' -b 'Logout' 'swaymsg exit' -b 'Suspend' 'systemctl suspend' -b 'Shutdown' 'systemctl shutdown' -b 'Reboot' 'systemctl reboot'"
    },
    "tray": {
        "icon-size": 21,
        "spacing": 10
    }
}