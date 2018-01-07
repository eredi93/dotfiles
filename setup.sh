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

setup() {

  # Ensure that the following actions
  # are made relative to this file's path.

  cd "${1}" || exit 1
  # tmp chackout to v2 branch
  git checkout js/v2

  if ! command -v python3 &> /dev/null ; then
     echo "python3 is not istalled 😢" >&2
     exit 1
  elif ! command -v pip3 &> /dev/null ; then
      echo "pip3 is not istalled 😢" >&2
      exit 1
  fi

  pip3 install -r requirements.txt 2>&1 &> /dev/null

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
