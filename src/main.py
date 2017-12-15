import os
import sys

from halo import Halo

import packages

from errors import SetupError
from helpers import get_os, is_supported_version, print_in_magenta, \
    download_and_untar


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


@Halo(text="Loading", spinner="dots")
def download_dotfiles():
    download_and_untar(DOTFILES_TARBALL_URL, DOTFILES_DIRECTORY)


def create_symbolic_links():
    for file_name in FILES_TO_SYMLINK:
        src = "{}/src/fixtures/{}".format(DOTFILES_DIRECTORY, file_name)
        dst = "{}/.{}".format(os.getenv("HOME"), file_name)
        spinner = Halo(text="{} → {}".format(src, dst), spinner="dots")

        try:
            if os.path.islink(dst):
                os.remove(dst)
            elif os.path.isfile(dst):
                os.rename(dst, "{}.local".format(dst))

            os.symlink(src, dst)
        except:
            spinner.fail(file_name)
        else:
            spinner.succeed(file_name)


def setup(sys_os):
    packages.setup(sys_os)
    packages.setup_shell()


def main():
    sys_os = get_os()

    verify_os(sys_os)

    print_in_magenta("\n • Download and extract archive\n\n")
    download_dotfiles()

    print_in_magenta("\n • Create symbolic links\n\n")
    create_symbolic_links()

    print_in_magenta("\n • Setup\n\n")
    setup(sys_os)


if __name__ == "__main__":
    try:
        main()
    except SetupError as e:
        sys.stderr.write("{}\n".format(str(e)))
        sys.exit(1)
