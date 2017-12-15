MINIMUM_MACOS_VERSION = "10.10"
MINIMUM_UBUNTU_VERSION = "14.04"

FILES_TO_SYMLINK = ["gitattributes", "gitignore", "tmux.conf", "vimrc", "zshrc"]

HUB_VERSION = "2.2.9"
PACKAGES = [
    ("macvim --env-std --with-cscope --with-lua --with-override-system-vim", "vim-gnome"),
    ("silversearcher-ag", "the_silver_searcher"),
    ("python", "pyhton-pip")
]
