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

  python_version=$(python -c 'import sys; print(sys.version_info[:][0])' 2> /dev/null)
  python_name="python"
  pip_name="python"

  if [[ $python_version != "3" ]]; then
     python_name="python3"
     pip_name="pip3"
  fi

  if ! command -v $python_name &> /dev/null ; then
     echo "Python 3.x is not istalled 😢" >&2
     exit 1
  elif ! command -v $pip_name &> /dev/null ; then
      echo "Python-pip 3.x is not istalled 😢" >&2
      exit 1
  fi

  $pip_name install -r requirements.txt 2>&1 &> /dev/null

  $python_name src/main.py
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

    git clone https://github.com/eredi93/dotfiles.git $dotfiles_dir

    setup $dotfiles_dir
}

main "$@"
