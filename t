HUB="hub-linux-amd64"

HUB_VERSION="2.2.5"
wget https://github.com/github/hub/releases/download/v$HUB_VERSION/$HUB-$HUB_VERSION.tgz -P /tmp
tar xvf /tmp/$HUB-$HUB_VERSION.tgz -C /tmp
/tmp/$HUB-$HUB_VERSION/install
rm -rf /tmp/$HUB


