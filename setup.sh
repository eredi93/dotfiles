#!/usr/bin/env bash

set -euo pipefail

# ----------------------------------------------------------------------
# | Environment Variables                                              |
# ----------------------------------------------------------------------
REPO_DIR=$(dirname "${0}")
ZSH_PLUGINS="zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search"

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

# ----------------------------------------------------------------------
# | Setup  Functions                                                   |
# ----------------------------------------------------------------------
setup_zsh() {
  echo -e ">> Setup ZSH as user Shell\n"

  if ! command -v zsh &> /dev/null ; then
    (>&2 echo "ERROR - ZSH is not installed")
    exit 1
  fi

  echo "Please enter your Mac user password to setup ZSH:"
  ask_for_sudo

  zsh_bin=$(command -v zsh)
  if ! sudo grep -q "${zsh_bin}" /etc/shells; then
    sudo sh -c "echo '${zsh_bin}' >> /etc/shells"
  fi

  if [[ $(uname) == "Linux" ]]; then
    sudo usermod --shell "${zsh_bin}" "$(whoami)"
  else
    sudo dscl . -create "/Users/${USER}" UserShell /opt/homebrew/bin/zsh
  fi
}

create_symbolic_links() {
  src_dir="${REPO_DIR}/files"
  dst_dir="${HOME}"

  echo -e ">> Creating symbolic links for files in ${src_dir}\n"

  for file in "${src_dir}"/*; do
    file_name=$(basename "${file}")
    # Skip config directory - handled separately
    if [ "${file_name}" = "config" ]; then continue; fi

    dst_file="${dst_dir}/.${file_name}"

    if [ ! -d "$(dirname "${dst_file}")" ]; then mkdir "$(dirname "${dst_file}")"; fi
    if [ -L "${dst_file}" ]; then rm "${dst_file}"; fi
    if [ -f "${dst_file}" ]; then mv "${dst_file}" "${dst_file}.local"; fi

    echo "${file} -> ${dst_file}"
    ln -s "$(realpath "${file}")" "${dst_file}"
  done

  # Handle ~/.config directory symlinks
  config_src="${src_dir}/config"
  if [ -d "${config_src}" ]; then
    mkdir -p "${HOME}/.config"
    for dir in "${config_src}"/*; do
      dir_name=$(basename "${dir}")
      config_dst="${HOME}/.config/${dir_name}"
      if [ -L "${config_dst}" ]; then
        rm "${config_dst}"
      elif [ -e "${config_dst}" ]; then
        mv "${config_dst}" "${config_dst}.local"
      fi
      echo "${dir} -> ${config_dst}"
      ln -s "$(realpath "${dir}")" "${config_dst}"
    done
  fi
}

install_oh_my_zsh() {
  if [ -d "${HOME}/.oh-my-zsh" ]; then
    echo -e ">> Oh My ZSH already installed. Reinstall....\n"
    rm -rf "${HOME}/.oh-my-zsh"
  fi

  echo -e ">> Installing Oh My ZSH\n"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --unattended"
}

oh_my_zsh_plugins() {
  echo -e ">> Installing Oh My ZSH Plugins\n"
  for plugin in $ZSH_PLUGINS; do
    repo="https://github.com/zsh-users/${plugin}.git"
    dst_dir="${HOME}/.oh-my-zsh/custom/plugins/${plugin}"

    if [ -d "${dst_dir}" ]; then rm -rf "${dst_dir}"; fi

    git clone "${repo}" "${dst_dir}" &> /dev/null
    echo "${plugin} successfully installed"
  done
}

tmux_tpm() {
  dst_dir="${HOME}/.tmux/plugins/tpm"
  echo -e ">> Installing Tmux TPM\n"

  if [ -d "${dst_dir}" ]; then rm -rf "${dst_dir}"; fi

  git clone https://github.com/tmux-plugins/tpm "${dst_dir}" &> /dev/null
  echo "Tmux TPM successfully installed"
}

setup() {
  # Ensure that the following actions
  # are made relative to this file's path.
  cd "${1}" || exit 1

  setup_zsh
  install_oh_my_zsh
  oh_my_zsh_plugins
  tmux_tpm
  create_symbolic_links

  echo "Dotfiles setup completed!"
}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
  dir="${DOTFILES_DIR-$HOME/.dotfiles}"

  rm -rf "${dir}"

  git clone git@github.com:eredi93/dotfiles.git "${dir}" &> /dev/null

  setup "${dir}"
}

main "$@"
