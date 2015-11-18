# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration
## bufix for PhpStorm (keyboard freeze) https://youtrack.jetbrains.com/issue/IDEA-78860
export IBUS_ENABLE_SYNC_MODE=1

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/.rvm/bin:$HOME/.local/bin:$PATH"

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias ll="ls -alhF --color"
alias ww="cd /srv/www/"
alias nmp="cd /srv/www/Nmp/"
alias vh="cd /etc/apache2/sites-available/"

# liste des alias visiable via l'alias cmd
cmd() {
  clear

  echo $fg[yellow]" system"
  echo $fg[green]"  ll					"$fg[default]"liste tous les éléments du dossier courant"
  echo $fg[green]"  ww					"$fg[default]"va dans le dossier /srv/www/"
  echo $fg[green]"  nmp					"$fg[default]"va dans le dossier /srv/www/Nmp/"
  echo $fg[green]"  vh					"$fg[default]"va dans le dossier /etc/apache2/sites-available/"
  echo $fg[green]"  debugIbus				"$fg[default]"Tapez cette commande lorsque le clavier ne repond plus (phpstorm)"
  
  echo ""
  echo $fg[yellow]" Symfony2"
  echo $fg[green]"  cc					"$fg[default]" ca:c equivalent [deprecated]"
  echo $fg[green]"  importTrans				"$fg[default]" maj les trad dans la BDD et dump trad js"
  echo $fg[green]"  boot client				"$fg[default]" bootstrap le design du client \"client\" [deprecated]"

  echo ""
  echo $fg[yellow]" git"
  echo $fg[green]"  upall branch[default:dev]		"$fg[default]" switch tout le projet sur la br branch"
  echo $fg[green]"  createAll branch			"$fg[default]" créé la branch \"branch\" récursivement sur tous les repos"
  echo $fg[green]"  switchAll branch			"$fg[default]" switch sur la branch \"branch\" si elle existe récusrivement sur tous les repos"
  echo $fg[green]"  gpr numéroPR nomBranch		"$fg[default]" switch un repo sur la pr \"numéroPR\" en créant la branch \"nomBranch\""
  echo $fg[green]"  gpro				"$fg[default]" reswitch le répo sur la branch précédante et supprime la branch de la PR"
}

## Canal TP - Symfony 2
cc() {
    app/console ca:c --no-warmup --client="$1"
    app/console cache:warmup --client="$1"
}

importTrans() {
    app/console lexik:translations:import --force
    app/console bazinga:js-translation:dump
    cc $1
}

## Git
alias uppstream=git fetch origin && (git co $1 ||:) && (git pull origin $1 ||:)
alias gsta="git stall"

upAll() {
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
alias upall=upAll

createAll() {
  git checkout -b $1
  git submodule foreach "git checkout -b $1"
}

switchIfExist() {
  if git branch | grep -q $1; then
    echo $fg[blue]"switching to $1"$fg[default]
    git checkout $1 > /dev/null
  else
    echo $fg[red]"pas de branch $1 sur ce repository"$fg[default]
  fi
}

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

## recup des modifs d'une PR
gpr() {
  if [ $# -lt 2 ]; then
    echo $fg[red]"wrong number of arguments"
    echo $fg[green]"grp "branch_name" "$fg[blue]"PR_number" $fg[default]"où branch_name le nom de la branch qui sera créé et PR_number est le numéro de Pull Request"
    return
  fi
  print $fg[blue]"Récupération des modifications de la PR "$fg[green]"$2"$fg[blue]" et création de la branche "$fg[green]"$1"$fg[default]
  git fetch origin pull/$2/head:$1
  git checkout $1 > /dev/null
}

## PR finie
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

boot() {
  echo "bootstraping the app for $1"
  fromDir=$(pwd)
  nmp
  app/console assets:install --client="$1"
  app/console assetic:dump --client="$1"
  cc $1
  cd $fromDir
}

debugIbus() {
  ibus-daemon -rd
  echo "plz type the following :"
  echo "setxkbmap fr"|xclip
  echo "use mouse middle click"
}

rmcms() {
  rm -rf /srv/www/MediaCMSApp/ezpublish/cache/* /srv/www/MediaCMSApp/ezpublish_legacy/var/cache/* /srv/www/MediaCMSApp/ezpublish_legacy/var/keolis_base/cache/*
}

