#! /bin/bash

REQUIRED_PACKAGES=( git curl wget zsh tmux )

which brew > /dev/null
if [ $? -eq 0 ] ; then
   OS="mac"
fi
which apt-get > /dev/null
if [ $? -eq 0 ] ; then
   OS="debian"
fi
which pacman > /dev/null
if [ $? -eq 0 ] ; then
   OS="arch"
fi
which yum > /dev/null
if [ $? -eq 0 ] ; then
   OS="redhat"
fi

install_package() {
  case "$OS" in
  "mac")
    brew install $1
    ;;
  "debian")
    sudo apt-get install -y $1
    ;;
  "arch")
    sudo pacman -S $1
    ;;
  "redhat")
    sudo yum install -y $1
    ;;
  esac
}

for i in "${REQUIRED_PACKAGES[@]}"
do
  install_package $i
done

if [ $OS = "mac" ]; then
  brew install macvim --env-std --with-cscope --with-lua --with-override-system-vim
  brew install python
  HUB="hub-darwin-amd64"
else
  install_package "terminator"
  install_package "vim-gnome"
  install_package "python-pip"
  HUB="hub-linux-amd64"
fi
if [ $OS = "debian" ]; then
  install_package "silversearcher-ag"
else
  install_package "the_silver_searcher"
fi

sudo pip install virtualenv virtualenvwrapper

HUB_VERSION="2.2.5"
wget https://github.com/github/hub/releases/download/v$HUB_VERSION/$HUB-$HUB_VERSION.tgz -P /tmp
tar xvf /tmp/$HUB-$HUB_VERSION.tgz -C /tmp
sudo /tmp/$HUB-$HUB_VERSION/install
rm -rf /tmp/$HUB*

pip install --user powerline-status
pip install --user git+git://github.com/powerline/powerline

if [ $OS = "mac" ]; then
  chsh -s /usr/local/bin/zsh
else
  wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
  wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
  if ! [ -d $HOME/.fonts ]; then
    mkdir -p $HOME/.fonts
  fi
  mv PowerlineSymbols.otf $HOME/.fonts/
  if ! [ -d $HOME/.config/fontconfig/conf.d ]; then
    mkdir -p $HOME/.config/fontconfig/conf.d/
  fi
  mv 10-powerline-symbols.conf $HOME/.config/fontconfig/conf.d/
  chsh -s /usr/bin/zsh
  fc-cache -vf $HOME/.fonts/
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
