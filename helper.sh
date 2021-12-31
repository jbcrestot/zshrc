#!/bin/bash

export COLOR_NC='\e[0m' # No Color
export COLOR_BLACK='\e[0;30m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_YELLOW='\e[0;33m'
export COLOR_LIGHT_YELLOW='\e[1;33m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_GRAY='\e[0;37m'
export COLOR_WHITE='\e[1;37m'


# liste des alias visiable via l'alias cmd
cmd() {
  clear

  print " "

  print " ""$COLOR_YELLOW""alias"
  print " ""$COLOR_GREEN""pépé                         ""$COLOR_GRAY""go to Provisioning Profiles folder"
  print " ""$COLOR_GREEN""proj                         ""$COLOR_GRAY""go to Prjects folder"
  print ""

  echo " ""$COLOR_YELLOW""system"
  echo " ""$COLOR_GREEN""ww                           ""$COLOR_GRAY""va dans le dossier contenant vos projets"
  
  echo ""
  echo " ""$COLOR_YELLOW""git"
  echo " ""$COLOR_GREEN""fap                          ""$COLOR_GRAY""git fetch --all --prune && git pull --rebase"
  echo " ""$COLOR_GREEN""gpr PRnumber branchName     ""$COLOR_GRAY"" switch repo pr \"numéroPR\" en créant la branch \"nomBranch\" ; si la branch existant déjà, on la met à jour"
  echo " ""$COLOR_GREEN""gpro                        ""$COLOR_GRAY"" reswitch le répo sur la branch précédante et supprime la branch de la PR"
  echo " ""$COLOR_GREEN""gif your-url?               ""$COLOR_GRAY"" remind you the syntax for adding gif into github"

  echo ""
  echo " ""$COLOR_YELLOW""mobile"
  echo " ""$COLOR_GREEN""sim                         ""$COLOR_GRAY"" launch last iOS simulator"
}

# For a full list of active aliases, run `alias`.
alias ww='cd $WWW'
alias pépé="cd ~/Library/MobileDevice/Provisioning\ Profiles/"
alias proj="cd ~/Projects"
alias n="npm run"
alias nt="npm run test"

############################################################### Git shortcut
# Fetch --all -prune && pull
fap() {
  print """$COLOR_CYAN""git fetch --all --prune ""$COLOR_GREEN""then ""$COLOR_CYAN""git pull --rebase""$COLOR_GRAY"""
  print "${fg[default]}";
  git fetch --all --prune && git pull --rebase
}

test() {
  print -P """$COLOR_LIGHT_YELLOW""test ""$COLOR_GREEN"" un peu de gris ""$COLOR_GRAY"" encore plus clair"
}

############################################ git Pull Request
# Git Pull Request
function gpr {
  if [ $# -lt 2 ]; then
    print "  ""$COLOR_RED""wrong number of arguments"
    print "  ""$COLOR_CYAN""gpr ""$COLOR_GREEN""\"branch_name\" \"PR_number\" ""$COLOR_GRAY""où branch_name le nom de la branch qui sera créé et PR_number est le numéro de Pull Request"
    return
  fi

  ## if current branch equal asked branch, we delete it to update the br
  BRANCH=$(git symbolic-ref HEAD --short 2> /dev/null)
  local BRANCH
  if [ "$BRANCH" = "$1" ]; then
    print "  ""$COLOR_LIGHT_YELLOW""Branch $1 already exist"
    gpro
  fi


  print "  ""$COLOR_CYAN""Récupération des modifications de la PR ""$COLOR_GREEN$2"" ""$COLOR_CYAN""et création de la branche ""$COLOR_GREEN$1$COLOR_GRAY"""
  git fetch origin pull/"$2"/head:"$1"
  git checkout "$1" > /dev/null
}

# Git Pull Request Over
gpro() {
  BRANCH=$(git symbolic-ref HEAD --short 2> /dev/null)
  local BRANCH
  if [[ -n "$BRANCH" ]];then
    git checkout master > /dev/null
    git branch -D "$BRANCH"
  else
    print "  ""$COLOR_CYAN""pas de branche"
  fi
}

# reminder for gif in github page
gif() {
  if [ $# -lt 1 ]; then
    print "  ""$COLOR_CYAN""![](""$COLOR_GREEN""your-url""$COLOR_CYAN"")""$COLOR_GRAY"" your-url represent the url of your gif"
    return
  fi

  print "  ""$COLOR_CYAN""![](""$1"")"
  echo "![](""$1"")" | pbcopy
}
