import os
import time
import subprocess
from halo import Halo

from constants import HUB_VERSION, PACKAGES
from helpers import print_in_green, download_and_untar
from errors import SetupError


DEV_NULL = subprocess.PIPE


def install_with_brew(pack):
    spinner = Halo(text=pack, spinner="dots")
    spinner.start()
    status = subprocess.Popen(["brew", "install", pack],
            stdout=DEV_NULL, stderr=DEV_NULL).wait()
    if status != 0:
        return spinner.fail(pack)
    spinner.succeed(pack)


def install_with_apt(pack):
    spinner = Halo(text=pack, spinner="dots")
    spinner.start()
    status = subprocess.Popen(["sudo", "apt-get", "install", "-y", pack],
            stdout=DEV_NULL, stderr=DEV_NULL).wait()
    if status != 0:
        return spinner.fail(pack)
    spinner.succeed(pack)


def install_hub(sys_os):
    spinner = Halo(text="hub", spinner="dots")
    spinner.start()
    arch = os.popen("uname -s").read().strip().lower()
    url = "https://github.com/github/hub/releases/download/" \
          "v{0}/hub-{1}-amd64-{0}.tgz".format(HUB_VERSION, arch)
    home_bin = os.path.expanduser("~/.bin")
    hub_bin = "{}/hub".format(home_bin)

    try:
        if not os.path.isdir(home_bin):
            os.mkdir(home_bin)
        if os.path.isfile(hub_bin):
            os.remove(home_bin)
        download_and_untar(url, hub_bin)
        spinner.succeed("hub")
    except:
        spinner.fail("hub")


def install(sys_os):
    if sys_os == "macos":
        for pack in [ x[0] for x in PACKAGES ]:
            install_with_brew(pack)
    elif sys_os == "ubuntu":
        for pack in [ x[1] for x in PACKAGES ]:
            install_with_apt(pack)
    else:
        raise SetupError("Unsupported OS: {}".format(sys_os))

    install_hub(sys_os)


def setup_zsh():
    print_in_green("set ZSH as default shell")
    spinner = Halo()
    if os.system("chsh -s /usr/bin/zsh") != 0:
        return spinner.fail("ZSH")
    spinner.succeed("ZSH")


def setup_omz():
    spinner = Halo(text="Oh-My-ZSH", spinner="dots")
    spinner.start()
    res = requests.get("https://raw.githubusercontent.com/robbyrussell/" \
        "oh-my-zsh/master/tools/install.sh")
    if res.status_code != 200:
        return spinner.fail("Oh-My-ZSH")

    status = subprocess.Popen(["sh", "-c", res.text],
            stdout=DEV_NULL, stderr=DEV_NULL).wait()
    if status != 0:
        return spinner.fail("Oh-My-ZSH")
    spinner.succeed("Oh-My-ZSH")
