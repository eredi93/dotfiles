import os
from halo import Halo

from constants import HUB_VERSION, PACKAGES
from helpers import download_and_untar
from errors import SetupError


def install_with_brew(pack):
    spinner = Halo(text=pack, spinner="dots")
    status = os.system("brew install -y {} > /dev/null".format(pack))
    if status == 0:
        spinner.succeed(pack)
    else:
        spinner.fail(pack)


def install_with_apt(pack):
    spinner = Halo(text=pack, spinner="dots")
    status = os.system("sudo apt-get install -y {} > /dev/null".format(cmd))
    if status == 0:
        spinner.succeed(pack)
    else:
        spinner.fail(pack)


def install_hub(sys_os):
    arch = os.popen("uname -s").read().strip().lower().strip
    url = "https://github.com/github/hub/releases/download/" \
          "v{0}/hub-{1}-amd64-{0}.tgz".format(HUB_VERSION, arch)
    home_bin = os.path.expanduser("~/.bin")

    if not os.path.isdir(home_bin):
        os.mkdir(home_bin)

    download_and_untar(url, "{}/hub")


def install(sys_os):
    if sys_os == "macos":
        func = install_with_brew
        packs = [ x[1] for x in PACKAGES ]
    elif sys_os == "ubuntu":
        func = install_with_apt
        packs = [ x[1] for x in PACKAGES ]
    else:
        raise SetupError("Unsupported OS: {}".format(sys_os))

    for pack in packs: func.__call__(pack)

    install_hub(sys_os)


def setup_shell():
    spinner = Halo(text="ZSH", spinner="dots")
    status = os.system("chsh -s /usr/bin/zsh && sh -c \"$(curl -fsSL " \
        "https://raw.githubusercontent.com/robbyrussell/" \
        "oh-my-zsh/master/tools/install.sh)\" > /dev/null")
    if status == 0:
        spinner.succeed("ZSH")
    else:
        spinner.fail("ZSH")
