
# liste des alias visiable via l'alias cmd
cmd() {
  clear

  print " \e[0;33malias"
  print "  \e[0;32mpépé                         \e[0;37mgo to Provisioning Profiles folder"
  print "  \e[0;32mproj                         \e[0;37mgo to Prjects folder"
  print ""

  echo " \e[0;33msystem"
  echo "  \e[0;32mww                           \e[0;37mva dans le dossier contenant vos projets"
  
  echo ""
  echo " \e[0;33mgit"
  echo "  \e[0;32mfap                          \e[0;37mgit fetch --all --prune && git pull --rebase"
  echo "  \e[0;32mgpr PRnumber branchName     \e[0;37m switch repo pr \"numéroPR\" en créant la branch \"nomBranch\" ; si la branch existant déjà, on la met à jour"
  echo "  \e[0;32mgpro                        \e[0;37m reswitch le répo sur la branch précédante et supprime la branch de la PR"

  echo ""
  echo " \e[0;33mmobile"
  echo "  \e[0;32msim                         \e[0;37m launch last iOS simulator"
}

# \e[0;31m red
# \e[0;32m green
# \e[0;36m cyan
# \e[0;33m yellow
# \e[0;37m gris

# For a full list of active aliases, run `alias`.
alias ww="cd $WWW"
alias pépé="cd ~/Library/MobileDevice/Provisioning\ Profiles/"
alias proj="cd ~/Projects"

############################################################### Git shortcut
# Fetch --all -prune && pull
fap() {
  printf "\e[0;36mgit fetch --all --prune \e[0;32mthen \e[0;36mgit pull --rebase\e[0;37m"
  print $fg[default];
  git fetch --all --prune && git pull --rebase
}

test() {
  print -P "\e[1;33mtest \e[0;32m un peu de gris \e[0;37m encore plus clair"
}

############################################ git Pull Request
# Git Pull Request
gpr() {
  if [ $# -lt 2 ]; then
    print "  \e[0;31mwrong number of arguments"
    print "  \e[0;36mgpr \e[0;32m\"branch_name\" \"PR_number\" \e[0;37moù branch_name le nom de la branch qui sera créé et PR_number est le numéro de Pull Request"
    return
  fi

  ## if current branch equal asked branch, we delete it to update the br
  local BRANCH=$(git symbolic-ref HEAD --short 2> /dev/null)
  if [ $BRANCH = $1 ]; then
    print "  \e[1;33mBranch $1 already exist"
    gpro
  fi


  print "  \e[0;36mRécupération des modifications de la PR \e[0;32m$2 \e[0;36met création de la branche \e[0;32m$1\e[0;37m"
  git fetch origin pull/$2/head:$1
  git checkout $1 > /dev/null
}

# Git Pull Request Over
gpro() {
  local BRANCH=$(git symbolic-ref HEAD --short 2> /dev/null)
  if [[ ! -z "$BRANCH" ]] then
    git checkout master > /dev/null
    git branch -D $BRANCH
  else
    print "  \e[0;36mpas de branche"
  fi
}
