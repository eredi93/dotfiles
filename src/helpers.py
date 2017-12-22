import os
import sys
import shutil
import codecs
import random
import tarfile
import tempfile

from termcolor import colored, cprint
from urllib.request import urlretrieve

def get_os():
    kernel_name = os.popen("uname -s").read().strip()

    if kernel_name == "Darwin":
        return "macos"
    elif kernel_name == "Linux" and os.path.isfile("/etc/lsb-release"):
        return "ubuntu"

    return kernel_name


def is_supported_version(version, supported_version):
    version = [int(v) for v in version.split(".")]
    supported_version = [int(v) for v in supported_version.split(".")]
    for i, s_n in enumerate(supported_version):
        if len(version) < (i + 1):
            v_n = 0
        else:
            v_n = version[i]
        if s_n > v_n:
            return False
    return True


def print_in_magenta(text):
    cprint(text, "magenta")


def print_in_green(text):
    cprint(text, "green")


def download_and_untar(url, dst):
    with tempfile.TemporaryDirectory() as dirpath:
        file_name = codecs.encode(os.urandom(6), 'hex').decode()
        tmp_file_path = "{}/{}".format(dirpath, file_name)

        urlretrieve(url, tmp_file_path)

        with tarfile.open(tmp_file_path) as tar:
            tar.extractall(dirpath)
            tar.close()

        files = os.listdir(dirpath)
        files.remove(file_name)

        shutil.move("{}/{}".format(dirpath, files[0]), dst)
