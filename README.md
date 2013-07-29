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