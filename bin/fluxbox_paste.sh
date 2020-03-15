#!/usr/bin/env bash
USAGE="Usage: _fluxbox_paste.sh [-ehr]

Options:
  -h        Show this help text
  -e        Edit before pasting
  -r        Use rich text mode
"

tmp_prim="/tmp/copy_clipboard_primary"
tmp_clip="/tmp/copy_clipboard_clipboard"
xclip              -o > "$tmp_prim"
xclip -selection c -o > "$tmp_clip"


function move_to_clipboard () {
  xclip -o | xclip -selection c
}
function move_to_primary () {
  xclip -selection c -o | xclip
}
function restore () {
  xclip              "$tmp_prim"
  xclip -selection c "$tmp_clip"
}
function paste () {
  wmname=$(xprop -id "$(xdotool getactivewindow)" WM_NAME | sed 's/.*= //' | tr -d '"')
  wmclass=$(xprop -id "$(xdotool getactivewindow)" WM_CLASS | sed 's/.*= //' | tr -d '"')

  # notify-send test "$wmname | $wmclass \n 111"
  # notify-send test "$(xclip -o) \n---\n $(xclip -selection c -o)"

  if [[ "$wmname" == "nvim" ]]; then
    xdotool key --clearmodifiers Escape i ctrl+r ctrl+o 0x2b Escape
  elif [[ "$wmname" =~ "tmuxinator" ]]; then
    move_to_primary
    xdotool key --clearmodifiers ctrl+y
    xclip "$tmp_prim"
  elif [[ "$wmclass" =~ "urxvt" ]]; then
    move_to_primary
    xdotool key --clearmodifiers ctrl+y
    xclip "$tmp_prim"
  else
    xdotool key --clearmodifiers ctrl+v
  fi
}

while getopts "her" opt; do
  case $opt in
    h ) echo "$USAGE" && exit 0;;
    e ) edit=1;;
    r ) rich=1;;
    * ) echo "$USAGE" && exit 1;;
  esac
done

# If no edit: only paste from primary clipboard and exit
[ -z "$edit" ] && move_to_clipboard && paste && restore && exit

# Save primary selection to file
file="/tmp/edit-with-vim_$(date +%F_%H:%M:%S)"
if [ -z "$rich" ]; then
  xclip -o > "$file"
else
  echo ":html:" > "$file"
  xclip -o -t text/html \
    | pandoc -f html --atx-headers --reference-links \
      -t markdown-raw_html-native_divs-native_spans-fenced_divs-bracketed_spans-header_attributes >> "$file"
fi

# Edit file
urxvt -e nvim +'set filetype=wiki' "$file"
[ ! -s "$file" ] && restore && exit
truncate -s -1 "$file"

# Save file to clipboard
if [[ $(head -n 1 "$file") == ":html:" ]]; then
  sed -i '1d' "$file"

  # Add meta header for Outlook emails
  window=$(xdotool getwindowname "$(xdotool getactivewindow)")
  if [[ $window =~ 'Outlook' ]]; then
    sed -i '1i<meta http-equiv="content-type" content="text/html; charset=utf-8">' "$file"
  fi

  # See here for more info om premailer
  # https://stackoverflow.com/questions/54816884/inline-css-with-pandoc
  pandoc -f markdown -t html -s --highlight-style=tango \
    -c ~/scripts/files/email.css "$file" \
    | python -m premailer -o "$file.html"

  xclip -selection c -t text/html "$file.html"
else
  xclip -selection c "$file"
fi

paste
