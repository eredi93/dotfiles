import os
import time
import subprocess
from halo import Halo

from constants import HUB_VERSION, PACKAGES
from helpers import print_in_green, download_and_untar
from errors import SetupError


def install_with_brew(pack):
    spinner = Halo(text=pack, spinner="dots")
    spinner.start()
    status = subprocess.Popen(["brew", "install", pack],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE).wait()
    if status == 0:
        spinner.succeed(pack)
    else:
        spinner.fail(pack)


def install_with_apt(pack):
    spinner = Halo(text=pack, spinner="dots")
    spinner.start()
    status = subprocess.Popen(["sudo", "apt-get", "install", "-y", pack],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE).wait()
    if status == 0:
        spinner.succeed(pack)
    else:
        spinner.fail(pack)


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
            time.sleep(5)
    elif sys_os == "ubuntu":
        for pack in [ x[1] for x in PACKAGES ]:
            install_with_apt(pack)
            time.sleep(5)
    else:
        raise SetupError("Unsupported OS: {}".format(sys_os))

    install_hub(sys_os)


def setup_shell():
    print_in_green("set ZSH as default shell")
    os.system("chsh -s /usr/bin/zsh")

    spinner = Halo(text="Oh-My-ZSH", spinner="dots")
    spinner.start()
    status = os.system("sh -c \"$(curl -fsSL " \
        "https://raw.githubusercontent.com/robbyrussell/" \
        "oh-my-zsh/master/tools/install.sh)\" > /dev/null")

    status = subprocess.Popen(["sh", "-c", "install", "-y", pack],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE).wait()
    if status == 0:
        spinner.succeed("Oh-My-ZSH")
    else:
        spinner.fail("Oh-My-ZSH")
