# Path to your oh-my-zsh installation.
export ZSH=/home/jbcrestot/.oh-my-zsh

if [[ -r ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/home/jbcrestot/.rvm/gems/ruby-2.2.1/bin:/home/jbcrestot/.rvm/gems/ruby-2.2.1@global/bin:/home/jbcrestot/.rvm/rubies/ruby-2.2.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/jdk1.8.0_51/bin:/usr/lib/jvm/jdk1.8.0_51/db/bin:/usr/lib/jvm/jdk1.8.0_51/jre/bin:/home/jbcrestot/.rvm/bin:/home/jbcrestot/.rvm/bin:/home/jbcrestot/.local/bin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

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
  
  echo ""
  echo $fg[yellow]" Symfony2"
  echo $fg[green]"  cc					"$fg[default]" ca:c equivalent [deprecated]"
  echo $fg[green]"  importTrans				"$fg[default]" maj les trad dans la BDD et dump trad js"
  echo $fg[green]"  boot client				"$fg[default]" bootstrap le design du client \"client\" [deprecated]"

  echo ""
  echo $fg[yellow]" git"
  echo $fg[green]"  upall branch[default:master]		"$fg[default]" switch tout le projet sur la br branch"
  echo $fg[green]"  createAll branch			"$fg[default]" créé la branch \"branch\" récursivement sur tous les repos"
  echo $fg[green]"  switchAll branch			"$fg[default]" switch sur la branch \"branch\" si elle existe récusrivement sur tous les repos"
  echo $fg[green]"  gpr numéroPR nomBranch		"$fg[default]" switch un repo sur la pr \"numéroPR\" en créant la branch \"nomBranch\""
  echo $fg[green]"  pr_over				"$fg[default]" reswitch le répo sur la branch précédante et supprime la branch de la PR"
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
    echo "pas d'argument, default: master"
    branch="master"
  else
    branch=$1
  fi

  echo "switching everybody to $branch"
  git fetch origin
  git checkout $branch
  git pull origin $branch
  git submodule foreach "git fetch origin && git checkout $branch && git pull origin $branch"
}

creatAll() {
  git checkout -b $1
  git submodule foreach "git checkout -b $1"
}

switchIfExist() {
  if git branch | grep -q $1; then
    echo "switching to $1"
    git checkout $1
  else
    echo "pas de branch $1 sur ce repository"
  fi
}

switchAll() {
  switchIfExist $1
  git submodule foreach "
if git branch | grep -q $1; then
    echo '   >>> switching to $1'
    git checkout $1
  else
    echo '   xxx pas de branch $1 sur ce repository'
  fi
"
}

## recup des modifs d'une PR
gpr() {
  if [ $# -lt 2 ]; then
    echo $fg[green]"grp "$fg[blue]"PR_number" "branch_name" $fg[default]"où PR_number est le numéro de Pull Request et branch_name le nom de la branch qui sera créé"
    return
  fi
  print $fg[blue]"Récupération des modifications de la PR "$fg[green]"$1"$fg[blue]" et création de la branche "$fg[green]"$2"$fg[default]
#  git fetch origin pull/$1/head:$2
#  git checkout $2
}

## PR finie
gpro() {
  local BRANCH=$(git symbolic-ref HEAD --short 2> /dev/null)
  if [[ ! -z "$BRANCH" ]] then
    print "Pull Request finie delete la branch $BRANCH"
    git checkout -
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
  clearCache $1
  cd $fromDir
}
