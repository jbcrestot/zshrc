# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(battery dir_writable time)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git)

export NVM_DIR="/Users/jbcrestot/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm use 8.11.3

source $ZSH/oh-my-zsh.sh
source ~/.commonprofile
# allow customization
source $HOME/zshrc/const.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias ll="ls -alhF --color"
alias ww="cd $WWW"
alias nmp="cd $WWW/Nmp/"
alias vh="cd $virtual_host_dir"
alias composer="composer.phar"
alias pépé="cd ~/Library/MobileDevice/Provisioning\ Profiles/"
# Load xdebug Zend extension with php command
alias php='php -dzend_extension=xdebug.so'
# PHPUnit needs xdebug for coverage. In this case, just make an alias with php command prefix.
alias phpunit='php ~/.composer/vendor/bin/phpunit'

# liste des alias visiable via l'alias cmd
cmd() {
  clear

  echo $fg[yellow]" system"
  echo $fg[green]"  ww					"$fg[default]"va dans le dossier contenant vos projets"
  echo $fg[green]"  nmp					"$fg[default]"va dans le dossier Nmp"
  echo $fg[green]"  vh					"$fg[default]"va dans le dossier ${virtual_host_dir}"
  echo $fg[green]"  debugIbus				"$fg[default]"Tapez cette commande lorsque le clavier ne repond plus (phpstorm)"
  
  echo ""
  echo $fg[yellow]" git"
  echo $fg[green]"  fap					"$fg[default]"git fetch --all --prune && git pull"
  echo $fg[green]"  gsa					"$fg[default]" git status on repo and submodules"
  echo $fg[green]"  upall branch[default:dev]		"$fg[default]" switch repo and submodules on branch \"br\""
  echo $fg[green]"  createAll branch			"$fg[default]" create branch \"branch\" récursivly on repo and submodules"
  echo $fg[green]"  switchAll branch			"$fg[default]" if exist, switch on branch \"branch\" recursivly on repo and submodules"
  echo $fg[green]"  gpr numéroPR nomBranch		"$fg[default]" switch repo pr \"numéroPR\" en créant la branch \"nomBranch\" ; si la branch existant déjà, on la met à jour"
  echo $fg[green]"  gpro					"$fg[default]" reswitch le répo sur la branch précédante et supprime la branch de la PR"
}

############################################################### Git shortcut
# Fetch --all -prune && pull
fap() {
  printf $fg[blue]"git fetch --all --prune"$fg[white]" then "$fg[blue]"git pull"
  print $fg[default];
  git fetch --all --prune && git pull
}


############################################################### Git submodule
# Git Status All submodule
gsa() {
  printf $fg[blue]"Entrée dans ";git config --get remote.origin.url|grep -P -o "CanalTP.*"|cut -d "/" -f2|cut -d "." -f1;
  printf $fg[white]"Sur la branch ";git symbolic-ref --short HEAD
  echo   $fg[white];git st -s

  echo   $fg[blue];git submodule foreach "printf $fg[white]'Sur la branch ';git symbolic-ref --short HEAD;printf $fg[default];git st -s;echo $fg[blue];"
}

# Update all submodule (git pull)
upall() {
  if [ $# -eq 0 ]; then
    echo $fg[blue]"pas d'argument, default: dev"$fg[default]
    branch="dev"
  else
    branch=$1
  fi

  printf $fg[blue]"switching everybody to $branch"
  echo $fg[yellow];git checkout $branch > /dev/null
  printf $fg[white];git pull origin $branch 2> /dev/null;echo $fg[default]
  printf $fg[blue];git submodule foreach "printf $fg[yellow];git checkout $branch > /dev/null && printf $fg[white];git pull origin $branch 2> /dev/null;echo $fg[blue]"
}

# create $branch on all submodule
createAll() {
  git checkout -b $1
  git submodule foreach "git checkout -B $1"
}

# Switch current repository into $branch
switchIfExist() {
  if git branch | grep -q $1; then
    echo $fg[blue]"switching to $1"$fg[default]
    git checkout $1 > /dev/null
  else
    echo $fg[red]"pas de branch $1 sur ce repository"$fg[default]
  fi
}

# Switch All submodule into $branch
switchAll() {
  switchIfExist $1
  git submodule foreach "
if git branch | grep -q $1; then
    echo $fg[blue]'   >>> switching to $1'$fg[default]
    git checkout $1 > /dev/null
  else
    echo $fg[red]'   xxx pas de branch $1 sur ce repository'$fg[default]
  fi
"
}

############################################ git Pull Request
# Git Pull Request
gpr() {
  if [ $# -lt 2 ]; then
    echo $fg[red]"wrong number of arguments"
    echo $fg[green]"grp "branch_name" "$fg[blue]"PR_number" $fg[default]"où branch_name le nom de la branch qui sera créé et PR_number est le numéro de Pull Request"
    return
  fi

  ## if current branch equal asked branch, we delete it to update the br
  local BRANCH=$(git symbolic-ref HEAD --short 2> /dev/null)
  if [ $BRANCH = $1 ]; then
    gpro
  fi

  print $fg[blue]"Récupération des modifications de la PR "$fg[green]"$2"$fg[blue]" et création de la branche "$fg[green]"$1"$fg[default]
  git fetch origin pull/$2/head:$1
  git checkout $1 > /dev/null
}

# Git Pull Request Over
gpro() {
  local BRANCH=$(git symbolic-ref HEAD --short 2> /dev/null)
  if [[ ! -z "$BRANCH" ]] then
    print "Pull Request finie delete la branch $BRANCH"
    git checkout - > /dev/null
    git branch -D $BRANCH
  else
    print "pas de branche"
  fi
}


LOCAL_DIR="local"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[ -d "$DIR/$LOCAL_DIR" ] && echo  'yes'

echo $DIR/$LOCAL_DIR
if [ -d "$DIR/zshrc/$LOCAL_DIR" ]; then
	ECHO "custom local detected, loading custom script"
	source "$DIR/zshrc/$LOCAL_DIR/custom.sh"
fi

