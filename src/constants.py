MINIMUM_MACOS_VERSION = "10.10"
MINIMUM_UBUNTU_VERSION = "14.04"

HUB_VERSION = "2.2.9"
PACKAGES = [
    (
        "vim --with-lua --with-override-system-vi --with-python",
        "vim"
    ),
    ("the_silver_searcher", "silversearcher-ag"),
    (None, "build-essential"),
    ("cmake", "cmake"),
    ("reattach-to-user-namespace", None),
    ("tmux", "tmux"),
    ("zsh", "zsh")
]
UBUNTU_REPOSITORIES = [
    "ppa:jonathonf/vim"
]
ZSH_PLUGINS = [
    "zsh-syntax-highlighting",
    "zsh-autosuggestions",
    "zsh-history-substring-search"
]
