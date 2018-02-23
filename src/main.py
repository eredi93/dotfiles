import os
import sys
import glob

from halo import Halo

import packages

from errors import SetupError
from constants import MINIMUM_MACOS_VERSION, MINIMUM_UBUNTU_VERSION
from helpers import get_os, is_supported_version, print_in_magenta


def verify_os(sys_os):
    if sys_os == "macos":
        os_version = os.popen("sw_vers -productVersion").read().strip()

        if not is_supported_version(os_version, MINIMUM_MACOS_VERSION):
            msg = "Sorry, this script is intended only for macOS {}".format(
                    MINIMUM_MACOS_VERSION)
            raise SetupError(msg)
    elif sys_os == "ubuntu":
        os_version = os.popen("lsb_release -d").read().strip().split(' ')[1]

        if not is_supported_version(os_version, MINIMUM_UBUNTU_VERSION):
            msg = "Sorry, this script is intended only for Ubuntu {}".format(
                    MINIMUM_UBUNTU_VERSION)
            raise SetupError(msg)
    else:
        msg = "Sorry, this script is intended only for macOS and Ubuntu!"
        raise SetupError(msg)


def create_symbolic_links():
    src_dir = "{}/files".format(os.path.dirname(os.path.realpath(__file__)))
    dst_dir = os.getenv("HOME")
    for src in glob.iglob("{}/*".format(src_dir)):
        file_name = os.path.basename(src)
        dst = "{}/.{}".format(dst_dir, file_name)
        dsr_dir = os.path.dirname(dst)
        if not os.path.exists(dsr_dir):
            os.makedirs(dst_dir)

        spinner = Halo(text="{} → {}".format(src, dst), spinner="dots")
        spinner.start()
        try:
            if os.path.islink(dst):
                os.remove(dst)
            elif os.path.isfile(dst):
                os.rename(dst, "{}.local".format(dst))

            os.symlink(src, dst)
            spinner.succeed(file_name)
        except:
            spinner.fail(file_name)


def setup(sys_os):
    packages.install(sys_os)
    packages.setup_zsh()
    packages.setup_omz()
    packages.setup_tmux()


def main():
    sys_os = get_os()

    verify_os(sys_os)

    print_in_magenta("\n • Create symbolic links\n")
    create_symbolic_links()

    print_in_magenta("\n • Setup\n")
    setup(sys_os)


if __name__ == "__main__":
    try:
        main()
    except SetupError as e:
        sys.stderr.write("{}\n".format(str(e)))
        sys.exit(1)
