# ------------------------------------------------------------------------------
#          FILE:  zshmarks.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Jocelyn Mallon
#       VERSION:  1.5.0
# ------------------------------------------------------------------------------

# Set BOOKMARKS_FILE if it doesn't exist to the default.
# Allows for a user-configured BOOKMARKS_FILE.
if [[ -z $BOOKMARKS_FILE ]] ; then
	export BOOKMARKS_FILE="$HOME/.bookmarks"
fi

# Create bookmarks_file it if it doesn't exist
if [[ ! -f $BOOKMARKS_FILE ]]; then
	touch $BOOKMARKS_FILE
fi

function bookmark() {
	local bookmark_name=$1
	if [[ -z $bookmark_name ]]; then
		echo 'Invalid name, please provide a name for your bookmark. For example:'
		echo '  bookmark foo'
		return 1
	else
    cur_dir="$(pwd)"
    # Replace /home/uname with $HOME
    if [[ "$cur_dir" =~ ^"$HOME"(/|$) ]]; then
      cur_dir="\$HOME${cur_dir#$HOME}"
    fi
    # Store the bookmark as folder|name
    bookmark="$cur_dir|$bookmark_name"
    if [[ -z $(grep "$bookmark" $BOOKMARKS_FILE) ]]; then
			echo $bookmark >> $BOOKMARKS_FILE
			echo "Bookmark '$bookmark_name' saved"
		else
			echo "Bookmark already existed"
			return 1
		fi
	fi
}

source_setenv() {
	local bookmark_name=$1
	# is there a setenv file to source
	if [[ -f "setenv-source-me.sh" ]]; then
		# if we have not already sourced it in the current zsh session ..
		setenv_var=`echo "setenv_${bookmark_name}" | sed "s/[^a-zA-Z0-9]/_/g"`
		if [[ -z ${(P)setenv_var} ]]; then
			echo "sourceing 'setenv-source-me.sh'"
			source setenv-source-me.sh
			# remember that we have sourced it
			eval "$setenv_var=sourced"
		fi
	fi
}

function jump() {
	local bookmark_name=$1
	local bookmark="$(grep "|$bookmark_name$" "$BOOKMARKS_FILE")"
	if [[ -z $bookmark ]]; then
		echo "Invalid name, please provide a valid bookmark name. For example:"
		echo "  jump foo"
		echo
		echo "To bookmark a folder, go to the folder then do this (naming the bookmark 'foo'):"
		echo "  bookmark foo"
		return 1
	else
		dir="${bookmark%%|*}"
		eval "cd \"${dir}\""
		source_setenv $bookmark_name
		unset dir
	fi
}

# Show a list of the bookmarks
function showmarks() {
	cat ~/.bookmarks | awk '{ printf "%-20s%-40s%s\n",$2,$1,$3}' FS=\|
}

# Delete a bookmark
function deletemark()  {
	local bookmark_name=$1
	if [[ -z $bookmark_name ]]; then
		echo 'Invalid name, please provide a name for your bookmark to delete. For example:'
		echo '  deletemark foo'
		return 1
	else
		local t
		t=$(mktemp -t bookmarks.XXXXXX) || exit 1
		trap "rm -f -- '$t'" EXIT
		sed "/$bookmark_name/d" "$BOOKMARKS_FILE" > "$t"
		mv "$t" "$BOOKMARKS_FILE"
		rm -f -- "$t"
		trap - EXIT
	fi
}

