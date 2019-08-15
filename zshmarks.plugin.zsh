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


__zshmarks_grep() {
  
  local outvar="$1"; shift
  local pattern="$1"
  local filename="$2"
  local file_contents="$(<"$filename")"
  local file_lines; file_lines=(${(f)file_contents})
  
  for line in "${file_lines[@]}"; do
    if [[ "$line" =~ "$pattern" ]]; then
      # eval "$outvar=\"$line\""
      return 0
    fi
  done
  
  return 1
  
}

function bookmark() {
  
  local bookmark_name=$1
  
  if [[ -z $bookmark_name ]]; then
    bookmark_name="${PWD:t}"
  fi
  
  if [[ -z $(egrep "^$(print -nD $PWD)\|*" "$BOOKMARKS_FILE" 2>/dev/null) ]]; then
    
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
  local bookmark
  
  if ! __zshmarks_grep bookmark "\\|$bookmark_name\$" "$BOOKMARKS_FILE"; then
    
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
  
  if [[ $# -eq 1 ]]; then
    
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
  
  local bookmark_line bookmark_search
  local bookmark_file="$(<"$BOOKMARKS_FILE")"
  local bookmark_array; bookmark_array=(${(f)bookmark_file});
  
  if [[ -z "$1" ]]; then
    
    bookmark_search="${PWD:t}\|*"
    
    if [[ -z ${bookmark_array[(r)$bookmark_search]} ]]; then
      echo "'${PWD:t}' not found in you bookmark , skipping."
    fi

    bookmark_line=${bookmark_array[(r)$bookmark_search]}
    bookmark_array=(${bookmark_array[@]/$bookmark_line})
    
  else
    for bookmark_name in $@; do
      
      bookmark_search="*\|${bookmark_name}"

      if [[ -z ${bookmark_array[(r)$bookmark_search]} ]]; then
        echo "'${bookmark_name}' not found, skipping."
      fi

      bookmark_line=${bookmark_array[(r)$bookmark_search]}
      bookmark_array=(${bookmark_array[@]/$bookmark_line})
      
    done
    
  fi
  
  printf '%s\n' "${bookmark_array[@]}" >! $BOOKMARKS_FILE
  
}
