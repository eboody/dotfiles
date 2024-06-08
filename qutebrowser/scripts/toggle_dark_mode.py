#!/bin/bash

python3 <<EOF
import json
import os

config_file_path = os.path.expanduser("~/.config/qutebrowser/config.py")

with open(config_file_path, 'r') as config_file:
    config_lines = config_file.readlines()

dark_mode_line = next((line for line in config_lines if 'config.set("colors.webpage.darkmode.enabled"' in line), None)

if dark_mode_line:
    if 'True' in dark_mode_line:
        new_dark_mode_line = dark_mode_line.replace('True', 'False')
    else:
        new_dark_mode_line = dark_mode_line.replace('False', 'True')

    config_lines[config_lines.index(dark_mode_line)] = new_dark_mode_line

    with open(config_file_path, 'w') as config_file:
        config_file.writelines(config_lines)
else:
    with open(config_file_path, 'a') as config_file:
        config_file.write('config.set("colors.webpage.darkmode.enabled", True)\n')
EOF

qutebrowser ':config-source'
