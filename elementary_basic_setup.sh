#! /bin/bash

# install chrome
sudo apt-get install -y libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
sudo apt-get install -f
rm google-chrome*.deb

# install spotify-client
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install -y spotify-client

# install elementary-tweaks
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:philip.scott/elementary-tweaks
sudo apt-get update
sudo apt-get install -y elementary-tweaks

# install numix
sudo apt-add-repository -y ppa:numix/ppa
sudo apt-get update
sudo apt-get install -y numix-icon-theme-circle numix-gtk-theme

# change default terminal
sudo update-alternatives --config x-terminal-emulator

# install docker
sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
sudo apt-get update
sudo apt-get install docker-ce
sudo usermod -aG docker $USER
