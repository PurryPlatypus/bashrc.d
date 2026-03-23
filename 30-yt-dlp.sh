
# installer / updater
alias update-yt-dlp='python3 -m pip install -U "yt-dlp[default,curl-cffi]" --break-system-packages; echo -e "\n\nYou might want to run update-deno as well.";'
alias update-deno='curl -fsSL https://deno.land/install.sh | sh'

# qq-tab complete (adjacent keys on QWERT* keyboard) for frequently used commands
alias qq-yt-dlp='yt-dlp --js-runtimes deno:/home/user/.deno/bin/deno'

# old / deprecated variants, just keeping 'em around
#alias update-yt-dlp='python3 -m pip install -U "yt-dlp[default]" --break-system-packages'
#alias update-yt-dlp='python3 -m pip install -U "yt-dlp[default,curl-cffi]" --break-system-packages'
