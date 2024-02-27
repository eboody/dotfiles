from libqtile import layout
from libqtile.config import Match
import re

from libqtile.layout.xmonad import MonadWide

layouts = [
    # layout.MonadTall(margin=8, border_focus='#5294e2', border_normal='#2c5380'),
    #layout.Columns(border_focus_stack='#d75f5f'),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    layout.MonadWide(
                margin=8, border_focus='#5294e2', 
                border_normal='#0d0d0d', 
                min_ratio=0.15, 
                max_ratio=.85,
                align = MonadWide._down
            ),

    layout.Spiral(ratio=0.5, ratio_increment=1.5, main_pane="top", clockwise=False, new_client_position="after_current", margin=8, border_focus='#5294e2', border_normal='#0d0d0d'),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
