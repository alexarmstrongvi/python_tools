#!/bin/bash

################################################################################
# Variable checks
function is_true() {
    local bool=$1
    [ "$bool" == true ]
}

function is_false() {
    local bool=$1
    [ "$bool" == false ]
}

function is_empty() {
    local var=$1
    [[ -z $var ]]
}
function is_not_empty() {
    local var=$1
    [[ -n "$var" ]]
}
function is_file() {
    local file=$1
    [[ -f "$file" ]]
}
function is_not_file() {
    local file=$1
    [[ ! -f "$file" ]]
}
function is_dir() {
    local dir=$1
    [[ -d "$dir" ]]
}
function is_not_dir() {
    local dir=$1
    [[ ! -d "$dir" ]]
}

################################################################################
# Print styles
# Taken from https://natelandau.com/bash-scripting-utilities/
bold="$(tput bold)"
underline="$(tput sgr 0 1)"
reset="$(tput sgr0)"

red="$(tput setaf 1)"
green="$(tput setaf 2)"
tan="$(tput setaf 3)"
blue="$(tput setaf 4)"
purple="$(tput setaf 5)"
grey="$(tput setaf 6)"
white="$(tput setaf 7)"

# Taken from https://raymii.org/s/snippets/Bash_Bits_Add_Color_Output_To_Your_Scripts.html
boldf() { echo -e "${bold}$*${reset}"; }
underlinef() { echo -e "${underline}$*${reset}"; }

redf()    { echo -e "${red}$*${reset}"; }
greenf()  { echo -e "${green}$*${reset}"; }
tan()     { echo -e "${tan}$*${reset}"; }
bluef()   { echo -e "${blue}$*${reset}"; }
purplef() { echo -e "${purple}$*${reset}"; }
greyf()   { echo -e "${grey}$*${reset}"; }
whitef()  { echo -e "${white}$*${reset}"; }

# Special formats
e_header() {
    printf "\n${bold}${purple}==========  %s  ==========${reset}\n" "$@"
}
e_arrow() {
    printf "➜ $@\n"
}
e_success() {
    echo -e "${green}✔ $*${reset}"
}
e_error() {
    printf "${red}✖ %s${reset}\n" "$@"
}
e_warning() {
    printf "${tan}➜ %s${reset}\n" "$@"
}
e_underline() {
    printf "${underline}${bold}%s${reset}\n" "$@"
}
e_bold() {
    printf "${bold}%s${reset}\n" "$@"
}
e_note() {
    printf "${underline}${bold}${blue}Note:${reset}  ${blue}%s${reset}\n" "$@"
}

################################################################################
# User input
seek_confirmation() {
  printf "\n${bold}$@${reset}"
  read -p " (y/n) " -n 1
  printf "\n"
  is_confirmed
}
# Test whether the result of an 'ask' is a confirmation
is_confirmed() {
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  return 0
fi
return 1
}

# Utilities
remove_PATH_duplicates() {
    if is_not_empty "$PATH"; then
      old_PATH=$PATH:; PATH=
      while is_not_empty "$old_PATH"; do
        x=${old_PATH%%:*}       # the first remaining entry
        case $PATH: in
          *:"$x":*) ;;         # already there
          *) PATH=$PATH:$x;;    # not there yet
        esac
        old_PATH=${old_PATH#*:}
      done
      PATH=${PATH#:}
      unset old_PATH x
    fi
}