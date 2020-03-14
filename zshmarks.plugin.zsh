#!/usr/bin/env zsh
# ------------------------------------------------------------------------------
#          FILE:  zshmarks.plugin.zsh
#   DESCRIPTION:  zsh plugin file.
#        AUTHOR:  Jocelyn Mallon
#       VERSION:  2.0.0
# ------------------------------------------------------------------------------

# Standarized $0 handling, following:
# https://github.com/zdharma/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

if [[ $PMSPEC != *f* ]] {
  fpath+=( "${0:h}/functions" )
}

# Set BOOKMARKS_FILE if it doesn't exist to the default.
# Allows for a user-configured BOOKMARKS_FILE.
if [[ -z "$BOOKMARKS_FILE" ]] ; then
  export BOOKMARKS_FILE="$HOME/.bookmarks"
fi

BOOKMARKS_FILE=${BOOKMARKS_FILE:A}

# Create bookmarks_file it if it doesn't exist`
if [[ ! -f $BOOKMARKS_FILE ]]; then
  echo -n > $BOOKMARKS_FILE
fi

autoload -Uz mark marks c delmark
