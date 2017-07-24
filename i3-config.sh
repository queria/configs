#!/bin/bash

cat <<"EOF"
#
# This file has been auto-generated by my configs/i3-config.sh
# Do any CHANGES to original script and NOT HERE.
#


set $mod Mod4
set $scripts $HOME/all/src/scripts

exec --no-startup-id $scripts/queria-autostart.sh

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
# This font is widely installed, provides lots of unicode glyphs, right-to-left
# text rendering and scalability on retina/hidpi displays (thanks to pango).
font pango:DejaVu Sans Mono 8
# Before i3 v4.8, we used to recommend this one as the default:
# font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
# The font above is very space-efficient, that is, it looks good, sharp and
# clear in small sizes. However, its unicode glyph coverage is limited, the old
# X core fonts rendering does not support right-to-left and this being a bitmap
# font, it doesn’t scale on retina/hidpi displays.

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

EOF

case "$(hostname)" in
    "ps-redtop")
        echo "workspace 1 output eDP1"
        echo "workspace 2 output DP2-2"
        echo "workspace 3 output eDP1"
        echo "workspace 4 output eDP1"
        ;;
    "satdesk")
        echo "workspace 1 output DVI-I-1"
        echo "workspace 2 output DVI-I-1"
        echo "workspace 3 output DVI-D-0"
        echo "workspace 4 output DVI-D-0"

        echo 'bindsym $mod+Shift+m exec --no-startup-id $scripts/monitor-switch.sh --safe home2'
        ;;
esac

cat <<"EOF"


# start dmenu (a program launcher)
# There also is the (new) i3-dmenu-desktop which only displays applications
# shipping a .desktop file. It is a wrapper around dmenu, so you need that
# installed.
# bindsym $mod+d exec --no-startup-id i3-dmenu-desktop

# change focus
bindsym $mod+comma focus left
bindsym $mod+semicolon focus right
bindsym $mod+a focus left
bindsym $mod+d focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+semicolon move right
bindsym $mod+c move position center

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+Control+Right split h
bindsym $mod+Control+Down split v
# split in vertical orientation

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen

# change container layout (stacked, tabbed, toggle split)
# bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+Shift+w layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+Home focus parent

# focus the child container
#bindsym $mod+d focus child

# switch to workspace
bindsym Control+F1 workspace 1
bindsym Control+F2 workspace 2
bindsym Control+F3 workspace 3
bindsym Control+F4 workspace 4
bindsym Control+F5 workspace 5
bindsym Control+F6 workspace 6

# move focused container to workspace
bindsym $mod+F1 move container to workspace 1
bindsym $mod+F2 move container to workspace 2
bindsym $mod+F3 move container to workspace 3
bindsym $mod+F4 move container to workspace 4
bindsym $mod+F5 move container to workspace 5
bindsym $mod+F6 move container to workspace 6

# reload the configuration file
#bindsym $mod+Shift+c reload
bindsym $mod+Shift+c reload, exec --no-startup-id "echo i3 config reloaded | osd_cat -O5 -d1"
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym j resize shrink width 10 px or 10 ppt
        bindsym k resize grow height 10 px or 10 ppt
        bindsym l resize shrink height 10 px or 10 ppt
        bindsym semicolon resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
        status_command $scripts/my3status
        position top
        #tray_output primary
}

# bindsym $mod+m bar hidden_state toggle
# bindsym $mod+n bar mode toggle


new_window normal
hide_edge_borders both
default_orientation auto
workspace_layout tabbed
floating_minimum_size 1 x 1

for_window [title="QSRun"] floating enable, border none
#for_window [class="Firefox"] move container to workspace 2, workspace 2
for_window [class="Gvim"] floating enable
for_window [class="explorer.exe" title="Emperor.exe"] floating enable, border none
for_window [class="explorer.exe"] floating enable, border none
for_window [class="winbox.exe"] floating enable
for_window [class="Winff"] floating enable
for_window [class="URxvt" title="^minipython$"] floating enable, border pixel 1, move absolute position 240px 135px
for_window [class="URxvt" title="^temp$"] floating enable, border pixel 1, move absolute position 240px 135px
for_window [title="Planet Explorers"] floating enable
for_window [title="^Event Tester$"] floating enable
for_window [title="^God_is_a_Cube-Age_of_DNA$"] floating enable
for_window [title="^Idling to Rule the Gods$" ] floating enable
for_window [class="^google-chrome$"] border pixel 1
for_window [class="^Steam$"] floating enable
for_window [class="^Steam$" title="^Steam$"] floating disable
for_window [class="^konversation$"] border pixel 1

#geometry { "x": 948, "y": 559 }

assign [class="Firefox"] 2
#assign [class="^URxvt$" instance="^RootShell$"] 4

# laptop control
bindsym XF86MonBrightnessDown exec --no-startup-id /usr/bin/xbacklight -dec 3 -time 100
bindsym XF86MonBrightnessUp exec --no-startup-id /usr/bin/xbacklight -inc 3 -time 100
bindsym XF86AudioRaiseVolume exec --no-startup-id $scripts/xosd-volume up
bindsym XF86AudioLowerVolume exec --no-startup-id $scripts/xosd-volume down
bindsym XF86AudioMute exec --no-startup-id $scripts/xosd-volume toggle
bindsym $mod+F7 exec --no-startup-id $scripts/monitor-switch.sh --safe
bindsym $mod+m exec --no-startup-id $scripts/monitor-switch.sh --safe

# terminal
bindsym $mod+Return workspace 1; exec --no-startup-id /usr/bin/urxvtc -e screen -x -R -S myterms -p +
bindsym Mod1+F1 exec --no-startup-id /usr/bin/urxvtc -title temp
bindsym $mod+Shift+Return workspace 4; exec --no-startup-id /usr/bin/urxvtc -e su
bindsym $mod+Mod1+Return exec --no-startup-id /usr/bin/urxvtc -title queria -e su - queria
bindsym $mod+Control+Return exec --no-startup-id /usr/bin/urxvtc -title shadow -e /bin/bash --rcfile ~/.bashnorc
bindsym $mod+t exec --no-startup-id $scripts/scrr2urxvt
bindsym $mod+Shift+t exec --no-startup-id $scripts/scrr2ssh office

### SESSION
# lock
bindsym $mod+e exec --no-startup-id $scripts/qslock
bindsym $mod+l exec --no-startup-id $scripts/qslock noirc
# suspend+lock
bindsym $mod+Shift+e exec --no-startup-id "sh -c 'qslock && sleep 0.8 && systemctl suspend'"
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+Delete exec --no-startup-id "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"
# shutdown
bindsym $mod+Shift+End exec --no-startup-id $scripts/i3-shutdown
# reboot
bindsym $mod+Shift+Escape exec --no-startup-id $scripts/i3-shutdown reboot

# window/workspace
bindsym $mod+q kill
bindsym Print workspace prev
bindsym Scroll_Lock workspace prev
bindsym Pause workspace next
bindsym $mod+XF86Back workspace prev
bindsym $mod+XF86Forward workspace next
bindsym XF86Back focus left
bindsym XF86Forward focus right

bindsym $mod+j focus left
bindsym $mod+k focus right

# apps
bindsym $mod+n exec --no-startup-id $HOME/all/src/nmcli-dmenu/nmcli_dmenu
bindsym Mod1+F2 exec --no-startup-id /usr/local/bin/dmenu_hist
bindsym Mod1+F3 exec --no-startup-id qsrun
bindsym XF86Launch1 exec --no-startup-id browser
bindsym XF86AudioMedia exec --no-startup-id browser
bindsym $mod+b exec --no-startup-id browser
bindsym $mod+XF86Launch1 exec --no-startup-id chrome
bindsym $mod+i exec /usr/bin/konversation
bindsym $mod+g exec /usr/bin/gvim
bindsym $mod+h exec --no-startup-id $scripts/headphones on
bindsym $mod+Shift+h exec --no-startup-id $scripts/headphones off
bindsym $mod+p exec --no-startup-id /usr/bin/urxvtc -title minipython -e ipython --no-confirm-exit
bindsym $mod+Shift+p exec --no-startup-id /usr/bin/urxvtc -e ipython --no-confirm-exit

bindsym $mod+s exec --no-startup-id $scripts/snap
bindsym $mod+Mod1+s exec --no-startup-id $scripts/qxdo space
bindsym $mod+Mod1+c exec --no-startup-id $scripts/qxdo
#bindsym XF86Calculator exec --no-startup-id $scripts/qxdo
bindsym $mod+Mod1+x exec --no-startup-id $scripts/qxdo stop
#bindsym XF86HomePage exec --no-startup-id $scripts/qxdo stop
bindsym $mod+Mod1+y exec --no-startup-id "sh -c 'pkill qxdo; pkill xdotool'"
bindsym $mod+o exec --no-startup-id $scripts/os-copy-deploy

bindsym $mod+Shift+f exec --no-startup-id $scripts/remind-me 5 Forge
EOF
