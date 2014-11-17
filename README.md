zshmarks
========

A port of [Bashmarks (by Todd Werth)](https://github.com/twerth/bashmarks), a simple command line bookmarking plugin, for oh-my-zsh

How to install
--------------

oh-my-zsh
---------
* Download the script or clone this repository in [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh) plugins directory:

        cd ~/.oh-my-zsh/custom/plugins
        git clone git://github.com/jocelynmallon/zshmarks.git

* Activate the plugin in `~/.zshrc`:

        plugins=( [plugins...] zshmarks [plugins...])

* Source `~/.zshrc`  to take changes into account:

        source ~/.zshrc

antigen
-------
Add `antigen bundle jocelynmallon/zshmarks` to your .zshrc where you're adding your other plugins. Antigen will clone the plugin for you and add it to your antigen setup the next time you start a new shell.

Commands/Usage:
------

* jump - used to 'jump' (cd) to the given bookmark directory. If the bookmark directory contains a 'setenv-source-me.sh' file, it will check to see if it's already been sourced, and source the file if necessary.

        jump 'foo'

* bookmark - used to create a new bookmark for your current working directory

        cd 'some_dir'
        bookmark 'foo'

* deletemark - used to delete a bookmark

        deletemark 'foo'

* showmarks - prints a list of all saved bookmarks, or print the directory information for a single, specific bookmark

        showmarks 'foo'
        $HOME/foo

Notes/Tips:
-----------

You can change the location of the bookmarks file (default is $HOME/.bookmarks) by adding the environment variable 'BOOKMARKS_FILE' to your shell profile.

        export BOOKMARKS_FILE="foo/bar"

If you were expecting this to be a port of similarly named [Bashmarks (by huyng)](https://github.com/huyng/bashmarks), you can setup zshmarks to behave in roughly the same way by adding the following aliases to your shell setup files/dotfiles:

        alias g="jump"
        alias s="bookmark"
        alias d="deletemark"
        alias p="showmarks"
        alias l="showmarks"

(You can also omit the "l" alias, and just use p without an argument to show all  bookmarks.)
