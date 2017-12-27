MINIMUM_MACOS_VERSION = "10.10"
MINIMUM_UBUNTU_VERSION = "14.04"

HUB_VERSION = "2.2.9"
PACKAGES = [
    ("vim --env-std --with-cscope --with-lua --with-override-system-vim", "vim"),
    ("the_silver_searcher", "silversearcher-ag"),
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