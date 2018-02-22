#!/bin/bash

# ----------------------------------------------------------------------
# | Helper Functions                                                   |
# ----------------------------------------------------------------------

ask_for_sudo() {

    # Ask for the administrator password upfront.

    sudo -v &> /dev/null

    # Update existing `sudo` time stamp
    # until this script has finished.
    #
    # https://gist.github.com/cowboy/3118588

    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &

}

install_python3() {
  os_name="$(uname -s)"

  if command -v python3 &> /dev/null ; then
    return 0
  fi

  if [ "$os_name" == "Darwin" ]; then
    if ! command -v brew &> /dev/null ; then
      echo ">> Installing Brew"
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo ">> Installing Python3"
    brew install python3

    return 0
  elif [ "$os_name" == "Linux" ] && [ -e "/etc/lsb-release" ]; then
    echo ">> Installing Python3"
    sudo apt install -y build-essential libssl-dev libffi-dev python3-dev python3-pip

    return 0
  else
    echo "Sorry, this script is intended only for macOS and Ubuntu!"
  fi

  return 1
}

setup() {
  # Ensure that the following actions
  # are made relative to this file's path.
  cd "${1}" || exit 1

  install_python3

  pip3 install -r requirements.txt 2>&1 &> /dev/null

  echo ">> Setup Environment"
  python3 src/main.py
}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    dotfiles_dir=$1

    if [ -z $dotfiles_dir ]; then
        dotfiles_dir="$HOME/.dotfiles"
    fi

    rm -rf $dotfiles_dir

    git clone https://github.com/eredi93/dotfiles.git $dotfiles_dir &> /dev/null

    setup $dotfiles_dir
}

main "$@"
