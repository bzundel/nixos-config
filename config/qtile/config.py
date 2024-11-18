import os
import subprocess
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord, ScratchPad, DropDown, Match
from libqtile.lazy import lazy
from widgets.systemd_service_widget import SystemdServiceWidget

mod = "mod1"
modsuper = "mod4"
terminal = "kitty"
hostname = subprocess.check_output(["hostname"]).decode().strip()

hostname_wlan_interface = {
    "cora": "wlp0s20f3",
    "corapad": "wlp3s0",
}

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.call(["sh", home])

keys = [
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),

    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    Key([mod, "shift"], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),

    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),

    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "e", lazy.shutdown(), desc="Exit Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "p", lazy.spawn("dmenu_run")),
    Key([modsuper], "l", lazy.spawn("slock")),
    Key([modsuper, "shift"], "l", lazy.spawn("lock_suspend.sh")),
    Key([mod], "space", lazy.widget["keyboardlayout"].next_keyboard(), desc="Switch to next keyboard layout"),
    Key([mod], "b", lazy.hide_show_bar(), desc="Toggle the bar"),

    Key([], "XF86AudioLowerVolume", lazy.widget["volume"].decrease_vol(), desc="Decrease volume"),
    Key([], "XF86AudioRaiseVolume", lazy.widget["volume"].increase_vol(), desc="Increase volume"),
    Key([], "XF86AudioMute", lazy.widget["volume"].mute(), desc="Toggle mute volume"),

    KeyChord([mod], "o", [
        Key([], "c", lazy.spawn("kitty --hold khal calendar"), desc="Launch new kitty terminal showing khal calendar"),
        Key([], "f", lazy.spawn("firefox"), desc="Launch firefox"),
        Key([], "t", lazy.spawn("thunderbird"), desc="Launch thunderbird"),
        Key([], "o", lazy.spawn("obsidian"), desc="Launch obsidian"),
        ],
        name="Launch"
    ),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

groups = [
    Group("term"),
    Group("www"),
    Group("dev"),
    Group("notes", matches=[Match(wm_class=["obsidian"])]),
    Group("pass", matches=[Match(wm_class=["keepassxc"])]),
    Group("misc"),
    Group("msg", layout="TreeTab", matches=[Match(wm_class=["thunderbird"]), Match(wm_class=["element"])]),
    Group("media"),
    ScratchPad("scratchpad", [DropDown("terminal", terminal, opacity=0.8)]),
]

for i, group in enumerate(groups):
    keys.extend([
        Key([mod], str(i + 1), lazy.group[group.name].toscreen(), desc=f"Switch to group {group.name}"),
        Key([mod, "shift"], str(i + 1), lazy.window.togroup(group.name, switch_group=True), desc=f"Switch to and move window to group {group.name}"),
    ])

keys.extend([
    Key([mod], "0", lazy.group["scratchpad"].dropdown_toggle("terminal")),
])

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.TreeTab(),
]

widget_defaults = dict(
    font="terminus",
    fontsize=14,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(name_transform=lambda name: name.upper()),
                widget.Systray(),
                widget.Sep(),
                widget.Wttr(location={"Frankfurt": "Home"}, format="%c%f"),
                widget.Sep(),
                SystemdServiceWidget(service_name="rclone-onedrive", display_name="Onedrive", show_icon=True),
                widget.Sep(),
                widget.DF(visible_on_warn=False, format="💾 {p} {r:.2f}%"),
                widget.Sep(),
                widget.KeyboardLayout(configured_keyboards=["us", "de"]),
                widget.Sep(),
                widget.Wlan(interface=hostname_wlan_interface[hostname], format="{essid} {percent:2.0%}"),
                widget.Sep(),
                #widget.Volume(unmute_format="🔊 {volume}%", mute_format="🔇"), # FIXME format options do not work
                widget.Volume(),
                widget.Sep(),
                widget.Battery(format="{char} {percent:2.0%} {hour:d}:{min:02d}", low_percentage=0.2, notify_below=20, empty_char="🪫", discharge_char="🔋", charge_char="⚡", full_char="🔋"),
                widget.Sep(),
                widget.Clock(format="%Y-%m-%d %a %H:%M", fmt="<b>{}</b>"),
            ],
            24,
        ),
    ),
]

# top bar without icons (too full)
# screens = [
#     Screen(
#         top=bar.Bar(
#             [
#                 widget.CurrentLayout(),
#                 widget.GroupBox(),
#                 widget.Prompt(),
#                 widget.WindowName(),
#                 widget.Chord(name_transform=lambda name: name.upper()),
#                 widget.Systray(),
#                 widget.Sep(),
#                 widget.Wttr(location={"Frankfurt": "Home"}, format="%C, %t (feels like %f)"),
#                 widget.Sep(),
#                 SystemdServiceWidget("rclone-onedrive"),
#                 widget.Sep(),
#                 widget.DF(visible_on_warn=False, format="{p} {r:.2f}%"),
#                 widget.Sep(),
#                 widget.KeyboardLayout(configured_keyboards=["us", "de"]),
#                 widget.Sep(),
#                 widget.Wlan(interface=hostname_wlan_interface[hostname], format="{essid} {percent:2.0%}"),
#                 widget.Sep(),
#                 widget.Volume(),
#                 widget.Sep(),
#                 widget.Battery(format="{char} {percent:2.0%} {hour:d}:{min:02d}", notify_below = 20),
#                 widget.Sep(),
#                 widget.Clock(format="%Y-%m-%d %a %H:%M", fmt="<b>{}</b>"),
#             ],
#             24,
#         ),
#     ),
# ]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
