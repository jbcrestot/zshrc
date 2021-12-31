## Installation

- install oh my zsh

- clone the repository in $HOME and replace ~/.zshrc with symbolic link from ~/zshrc/.zshrc

- touch ~/zshrc/local/custom.sh
  (put here, the very specific things on this computer)

## Theme

default theme is powerlevel10k

install power10k zsh theme : https://github.com/romkatv/powerlevel10k

## brew

## ruby

[install rvm](https://rvm.io/rvm/install#try-out-your-new-rvm-installation)

```
❯ \curl -sSL https://get.rvm.io | bash -s stable --ruby
[...]
❯ type rvm | head -n 1
rvm is a shell function from /Users/jb/.rvm/scripts/cli
❯ rvm list known
❯ rvm use 3.0
Using /Users/jb/.rvm/gems/ruby-3.0.0
❯ rvm use 3.0 --d
❯ ruby -v
ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [arm64-darwin20]
❯ rvm use 3.0 --default
Using /Users/jb/.rvm/gems/ruby-3.0.0
```

## node

use nvm

## usage

common file between computers

- zshrc_profile main file (try to keep it clean)
- helper.sh contains custom commands : type `cmd` to see the list of commands

Dedicated files for local installation

- local/custom.sh contain command needed for specific softwares
- const.sh contain exports and other constants
