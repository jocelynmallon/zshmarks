zshmarks
========

A port of [Bashmarks (by Todd Werth)](https://github.com/twerth/bashmarks), a simple command line bookmarking plugin, for oh-my-zsh

How to install
--------------

* Download the script or clone this repository in [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh) plugins directory:

        cd ~/.oh-my-zsh/custom/plugins
        git clone git://github.com/jocelynmallon/zshmarks.git

* Activate the plugin in `~/.zshrc`:

        plugins=( [plugins...] zshmarks [plugins...])

* Source `~/.zshrc`  to take changes into account:

        source ~/.zshrc

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
        $HOMR/foo

Notes/Tips:
-----------

You can change the location of the bookmarks file (default is $HOME/.bookmarks) by adding the environment variable 'BOOKMARKS_FILE' to your shell profile.

        export BOOKMARKS_FILE="foo/bar"

