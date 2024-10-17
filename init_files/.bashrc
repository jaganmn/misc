alias sudo="sudo "

if ls --group-directories-first &> /dev/null; then
alias ls="ls -AFbh --color=auto --group-directories-first"
else
alias ls="ls -AFGbh"
fi

alias R="R --quiet --no-save --no-restore"
alias discord="/Applications/Discord.app/Contents/MacOS/Discord"
alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs"
alias firefox="/Applications/Firefox.app/Contents/MacOS/firefox"
alias safari="/Applications/Safari.app/Contents/MacOS/Safari"
alias slack="/Applications/Slack.app/Contents/MacOS/Slack"
alias systemsettings="/System/Applications/System\ Settings.app/Contents/MacOS/System\ Settings"
alias teams="/Applications/Microsoft\ Teams.app/Contents/MacOS/Teams"
alias thunderbird="/Applications/Thunderbird.app/Contents/MacOS/thunderbird"
alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"
alias zoom="/Applications/zoom.us.app/Contents/MacOS/zoom.us"
alias zulip="/Applications/Zulip.app/Contents/MacOS/Zulip"
