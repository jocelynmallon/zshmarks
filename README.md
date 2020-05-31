# zshmarks

A port of [Bashmarks (by Todd Werth)](https://github.com/twerth/bashmarks), a simple command line bookmarking plugin, for oh-my-zsh

## Commands/Usage:

* `c` - used to `cd` to the given bookmark directory.

```sh
c foo
```

* `mark` - used to create a new bookmark for your current working directory

```sh
cd 'some_dir'
mark foo
# Or
mark # Will be added as `some_dir`
```

* `delmark` - used to delete a bookmark

```sh
delmark foo
# Or
delmark foo bar baz # Remove multiple bookmarks
# Or
delmark # Will delete current dir from bookmarks
```

* `marks` - prints a list of all saved bookmarks, or print the directory information for a single, specific bookmark

```sh
marks # Show all marks
# Or 
marks foo # Show path to bookmark
```

## Notes/Tips:

You can change the location of the bookmarks file (default is $HOME/.bookmarks) by adding the environment variable 'BOOKMARKS_FILE' to your shell profile.

```sh
export BOOKMARKS_FILE="foo/bar"
```

If you were expecting this to be a port of similarly named [Bashmarks (by huyng)](https://github.com/huyng/bashmarks), you can setup zshmarks to behave in roughly the same way by adding the following aliases to your shell setup files/dotfiles:

```sh
alias g="c"
alias s="mark"
alias d="delmark"
alias p="marks"
alias l="marks"
```

(You can also omit the "l" alias, and just use p without an argument to show all  bookmarks.)

# How to install

## [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh)

* Download the script or clone this repository in [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh) plugins directory:

```sh
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zpm-zsh/zshmarks.git
```

* Activate the plugin in `~/.zshrc`:

```sh
plugins=( [plugins...] zshmarks [plugins...])
```

* Restart shell

## [zpm](https://github.com/zpm-zsh/zpm)

Add the following to your .zshrc file somewhere after you source zpm.

```sh
zpm load "zpm-zsh/zshmarks"
```

## [antigen](https://github.com/zsh-users/antigen)

Add `antigen bundle zpm-zsh/zshmarks` to your .zshrc where you're adding your other plugins. Antigen will clone the plugin for you and add it to your antigen setup the next time you start a new shell.

## [prezto](https://github.com/sorin-ionescu/prezto)

For most people the easiest way to use zshmarks with [prezto](https://github.com/sorin-ionescu/prezto) is to manually clone the zshmarks repo to a directory of your choice (e.g. /usr/local or ~/bin) and symlink the zshmarks folder into your zpretzo/modules folder:

```sh
ln -s ~/bin/zshmarks ~/.zprezto/modules/zshmarks
```

Alternatively, you can add the zshmarks repository as a submodule to your prezto repo by manually editing the '.gitmodules' file:

```ini
[submodule "modules/zshmarks"]
        path = modules/zshmarks
        url = https://github.com/zpm-zsh/zshmarks.git
```

Then make sure you activate the plugin in your .zpreztorc file:

```sh
zstyle ':prezto:load' pmodule \
zshmarks \
...
```

## [zplug](https://github.com/zplug/zplug)

Add the following to your .zshrc file somewhere after you source zplug.

```sh
zplug "zpm-zsh/zshmarks"
```
