# ------------------------------------------------------------------------------
#          FILE:  zshmarks.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Jocelyn Mallon
#       VERSION:  1.7.0
# ------------------------------------------------------------------------------

# Set BOOKMARKS_FILE if it doesn't exist to the default.
# Allows for a user-configured BOOKMARKS_FILE.
if [[ -z $BOOKMARKS_FILE ]] ; then
	export BOOKMARKS_FILE="$HOME/.bookmarks"
fi

# Check if $BOOKMARKS_FILE is a symlink.
if [[ -L $BOOKMARKS_FILE ]]; then
  BOOKMARKS_FILE=$(readlink $BOOKMARKS_FILE)
fi

# Create bookmarks_file it if it doesn't exist
if [[ ! -f $BOOKMARKS_FILE ]]; then
	touch $BOOKMARKS_FILE
fi

_zshmarks_move_to_trash(){
  if [[ $(uname) == "Linux"* || $(uname) == "FreeBSD"* || ZSHMARKS_SKIP_TRASH != "false" ]] ; then
    label=`date +%s`
    mkdir -p ~/.local/share/Trash/info ~/.local/share/Trash/files
    \mv "${BOOKMARKS_FILE}.bak" ~/.local/share/Trash/files/bookmarks-$label
    echo "[Trash Info]
Path=/home/"$USER"/.bookmarks
DeletionDate="`date +"%Y-%m-%dT%H:%M:%S"`"
">~/.local/share/Trash/info/bookmarks-$label.trashinfo
  elif [[ $(uname) = "Darwin" ]]; then
    \mv "${BOOKMARKS_FILE}.bak" ~/.Trash/"bookmarks"$(date +%H-%M-%S)
  else
    \rm -f "${BOOKMARKS_FILE}.bak"
  fi
}

function bookmark() {
	local bookmark_name=$1
	if [[ -z $bookmark_name ]]; then
        bookmark_name="${PWD##*/}"
    fi
    cur_dir="$(pwd)"
    # Replace /home/uname with $HOME
    if [[ "$cur_dir" =~ ^"$HOME"(/|$) ]]; then
        cur_dir="\$HOME${cur_dir#$HOME}"
    fi
    # Store the bookmark as folder|name
    bookmark="$cur_dir|$bookmark_name"
    if [[ -z $(grep "$bookmark" $BOOKMARKS_FILE 2>/dev/null) ]]; then
        echo $bookmark >> $BOOKMARKS_FILE
        echo "Bookmark '$bookmark_name' saved"
    else
        echo "Bookmark already existed"
        return 1
    fi
}

__zshmarks_zgrep() {
	local outvar="$1"; shift
	local pattern="$1"
	local filename="$2"
	local file_contents="$(<"$filename")"
	local file_lines; file_lines=(${(f)file_contents})
	for line in "${file_lines[@]}"; do
		if [[ "$line" =~ "$pattern" ]]; then
			eval "$outvar=\"$line\""
			return 0
		fi
	done
	return 1
}

function jump() {
	local bookmark_name=$1
	local bookmark
	if ! __zshmarks_zgrep bookmark "\\|$bookmark_name\$" "$BOOKMARKS_FILE"; then
		echo "Invalid name, please provide a valid bookmark name. For example:"
		echo "  jump foo"
		echo
		echo "To bookmark a folder, go to the folder then do this (naming the bookmark 'foo'):"
		echo "  bookmark foo"
		return 1
	else
		local dir="${bookmark%%|*}"
		eval "cd \"${dir}\""
	fi
}

# Show a list of the bookmarks
function showmarks() {
  local bookmark_file="$(<"$BOOKMARKS_FILE")"
  local bookmark_array; bookmark_array=(${(f)bookmark_file});
  local bookmark_name bookmark_path bookmark_line
  if [[ $# -eq 1 ]]; then
    bookmark_name="*\|${1}"
    bookmark_line=${bookmark_array[(r)$bookmark_name]}
    bookmark_path="${bookmark_line%%|*}"
    bookmark_path="${bookmark_path/\$HOME/~}"
    printf "%s \n" $bookmark_path
  else
    for bookmark_line in $bookmark_array; do
      bookmark_path="${bookmark_line%%|*}"
      bookmark_path="${bookmark_path/\$HOME/~}"
      bookmark_name="${bookmark_line#*|}"
      printf "%s\t\t%s\n" "$bookmark_name" "$bookmark_path"
    done
  fi
}

# Delete a bookmark
function deletemark()  {
  local bookmark_name=$1
  if [[ -z $bookmark_name ]]; then
    printf "%s \n" "Please provide a name for your bookmark to delete. For example:"
    printf "\t%s \n" "deletemark foo"
    return 1
  else
    local bookmark_line bookmark_search
    local bookmark_file="$(<"$BOOKMARKS_FILE")"
    local bookmark_array; bookmark_array=(${(f)bookmark_file});
    bookmark_search="*\|${bookmark_name}"
    if [[ -z ${bookmark_array[(r)$bookmark_search]} ]]; then
      eval "printf '%s\n' \"'${bookmark_name}' not found, skipping.\""
    else
      \cp "${BOOKMARKS_FILE}" "${BOOKMARKS_FILE}.bak"
      bookmark_line=${bookmark_array[(r)$bookmark_search]}
      bookmark_array=(${bookmark_array[@]/$bookmark_line})
      eval "printf '%s\n' \"\${bookmark_array[@]}\"" >! $BOOKMARKS_FILE
      _zshmarks_move_to_trash
    fi
	fi
}

