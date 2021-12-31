#!/bin/bash

# ---- start of early initialization ----
# this need to be before instant prompt to be executed
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# load custom local const
source "$DIR/local/custom.sh"
# ---- end of early initialization ----

# ---- start of p10k initialization ----
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh 	# load personal prompt config
ZSH_THEME=powerlevel10k/powerlevel10k 			# load powerlevel10k
# ---- end of p10k initialization ----

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git)

source $ZSH/oh-my-zsh.sh
source $DIR/helper.sh # load helping command -> to see them type `cmd`
# customization initialization
source $DIR/local/const.sh # load common constants

# nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export POST_PATH_RVM="$POST_PATH:$HOME/.rvm/bin"

# final PATH setup
export PATH="/usr/local/sbin:$PRE_PATH:$PATH:$POST_PATH_RVM"
