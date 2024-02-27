#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f ~/.welcome_screen ]] && . ~/.welcome_screen

_set_liveuser_PS1() {
	PS1='[\u@\h \W]\$ '
	if [ "$(whoami)" = "liveuser" ]; then
		local iso_version="$(grep ^VERSION= /usr/lib/endeavouros-release 2>/dev/null | cut -d '=' -f 2)"
		if [ -n "$iso_version" ]; then
			local prefix="eos-"
			local iso_info="$prefix$iso_version"
			PS1="[\u@$iso_info \W]\$ "
		fi
	fi
}
_set_liveuser_PS1
unset -f _set_liveuser_PS1

ShowInstallerIsoInfo() {
	local file=/usr/lib/endeavouros-release
	if [ -r $file ]; then
		cat $file
	else
		echo "Sorry, installer ISO info is not available." >&2
	fi
}

# alias ls='ls --color=auto'
# alias ll='ls -lav --ignore=..'   # show long listing of all except ".."
# alias l='ls -lav --ignore=.?*'   # show long listing but no hidden dotfiles except "."

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100 # limits recursive functions, see 'man bash'

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

################################################################################
## Some generally useful functions.
## Consider uncommenting aliases below to start using these functions.
##
## October 2021: removed many obsolete functions. If you still need them, please look at
## https://github.com/EndeavourOS-archive/EndeavourOS-archiso/raw/master/airootfs/etc/skel/.bashrc

_open_files_for_editing() {
	# Open any given document file(s) for editing (or just viewing).
	# Note1:
	#    - Do not use for executable files!
	# Note2:
	#    - Uses 'mime' bindings, so you may need to use
	#      e.g. a file manager to make proper file bindings.

	if [ -x /usr/bin/exo-open ]; then
		echo "exo-open $@" >&2
		setsid exo-open "$@" >&/dev/null
		return
	fi
	if [ -x /usr/bin/xdg-open ]; then
		for file in "$@"; do
			echo "xdg-open $file" >&2
			setsid xdg-open "$file" >&/dev/null
		done
		return
	fi

	echo "$FUNCNAME: package 'xdg-utils' or 'exo' is required." >&2
}

#------------------------------------------------------------

## Aliases for the functions above.
## Uncomment an alias if you want to use it.
##

# alias ef='_open_files_for_editing'     # 'ef' opens given file(s) for editing
# alias pacdiff=eos-pacdiff
################################################################################

. "$HOME/.cargo/env"

export PATH=/home/eran/.local/bin/:$PATH
export FLYCTL_INSTALL="/home/eran/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
export LOCALSTACK_API_KEY=1Gf5qkfWoN
export DOCKER_BUILDKIT=1

eval "$(starship init bash)"

alias ls="exa"
alias cat="bat"

alias cw="cargo watch -c -q -w src/ -x \"run\""
alias ct="cargo watch -c -q -w tests/ -x \"test -q quick_dev -- --nocapture\""
alias clippy="cargo clippy -- -W clippy::pedantic -W clippy::nursery -W clippy::unwrap_used"

alias brc="lvim ~/.bashrc"
alias sb="source ~/.bashrc"

alias vim="lvim"

alias kb="~/scripts/keyboard_setup.sh"
alias la="exa -la"
alias thunderstorm="mpv --loop ~/Music/thunderstorm.flac"

alias ecdb="ssh -i ~/.aws/ec2/db_key.pem ubuntu@34.211.115.133"
alias db_tunnel="ssh -i ~/.aws/ec2/db_key.pem -N -L 5432:eran-codes.cxesap8f2qj0.us-west-2.rds.amazonaws.com:5432 ubuntu@ec2-34-211-115-133.us-west-2.compute.amazonaws.com"
alias ppsql="psql --host=localhost --port=5432 --dbname=mydatabase --username=myuser"
alias update_ec2="rsync -e \"ssh -i ~/.aws/ec2/db_key.pem\" -av --exclude-from=\"/home/eran/rsync_exclude.txt\" ~/code/pulsepoint/* ubuntu@34.211.115.133:pulsepoint"

alias qtilec="cd ~/.config/qtile && lvim ."

alias pps="cd ~/code/pulsepoint/server"
alias ppf="cd ~/code/pulsepoint/frontend"

alias gameres="xrandr --output USB-C-0 --mode 1280x720"
alias defres="xrandr --output USB-C-0 --mode 2560x2880"
alias redb="sqlx migrate revert && sqlx migrate run && cargo run --bin seed"

alias rotate="xrandr --output USB-C-0 --rotate"
alias yuzu="/home/eran/Downloads/Switch/yuzu-mainline-20230821-6500b6750.AppImage & disown"

alias stardew="unison /home/eran/.config/StardewValley/Saves/ mtp://Unisoc_Unisoc_Phone_56153256586008/Internal shared storage/Android/data/com.chucklefish.stardewvalley/files/Saves/"
eval "$(zoxide init --cmd cd bash)"
