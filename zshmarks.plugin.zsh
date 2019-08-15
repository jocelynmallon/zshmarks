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
  BOOKMARKS_FILE=${BOOKMARKS_FILE:A}
fi

# Create bookmarks_file it if it doesn't exist
if [[ ! -f $BOOKMARKS_FILE ]]; then
  touch $BOOKMARKS_FILE
fi

function bookmark() {
  
  local bookmark_name=$1
  
  if [[ -z $bookmark_name ]]; then
    bookmark_name="${PWD:t}"
  fi
  
  # Is root dir?
  if [[ -z $bookmark_name ]]; then
    bookmark_name="/"
  fi
  
  if ! egrep -q "^$(print -nD $PWD)\|" "$BOOKMARKS_FILE"; then
    
    # Store the bookmark as folder|name
    echo "$(print -nD $PWD)|$bookmark_name" >> $BOOKMARKS_FILE
    echo "Bookmark '$bookmark_name' saved"
    
    return 0
    
  fi
  
  echo "Bookmark already existed"
  return 1
  
}

function jump() {
  
  local bookmark_name="$1"
  local bookmark; bookmark=$(egrep "\|${bookmark_name}$" "$BOOKMARKS_FILE" 2>/dev/null)
  
  if [[ -z "$bookmark" ]] ; then
    
    echo "Invalid name, please provide a valid bookmark name. For example:"
    echo "  jump foo"
    echo
    echo "To bookmark a folder, go to the folder then do this (naming the bookmark 'foo'):"
    echo "  bookmark foo"
    return 1
    
  else
    
    local dir="${bookmark%%|*}"
    cd ${dir//\~/$HOME}
    
  fi
  
}

# Show a list of the bookmarks
function showmarks() {
  
  local bookmark_file="$(<"$BOOKMARKS_FILE")"
  local bookmark_array; bookmark_array=(${(f)bookmark_file});
  local bookmark_name bookmark_path bookmark_line
  
  if [[ -n "$1" ]]; then
    
    bookmark_name="*\|${1}"
    bookmark_line=${bookmark_array[(r)$bookmark_name]}
    bookmark_path="${bookmark_line%%|*}"
    printf "%s \n" $bookmark_path
    
  else
    printf "$bookmark_file" | column -s '|' -o '    ' -t
  fi
  
}

# Delete a bookmark
function deletemark()  {
  
  local bookmark_search
  local bookmark_file="$(<"$BOOKMARKS_FILE")"
  
  if [[ -z "$1" ]]; then
    
    bookmark_search="$(print -D $PWD)\|*"
    
    if ! egrep -q "$bookmark_search" <<< "$bookmark_file"; then
      echo "'$(print -D $PWD)' not found in you bookmark , skipping."
    fi

    bookmark_file="$(egrep -v "$bookmark_search" <<< $bookmark_file )"

  else
    
    for bookmark_name in $@; do

      bookmark_search="*\|${bookmark_name}"

      if ! egrep -q "$bookmark_search" <<< "$bookmark_file"; then
        echo "'${bookmark_name}' not found, skipping."
      fi

      bookmark_file="$(egrep -v "$bookmark_search" <<< $bookmark_file )"

    done

  fi

  printf '%s\n' "${bookmark_file}" >! $BOOKMARKS_FILE

}
