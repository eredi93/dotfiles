MINIMUM_MACOS_VERSION = "10.10"
MINIMUM_UBUNTU_VERSION = "14.04"

DOTFILES_REPOSITORY = "eredi93/dotfiles"
DOTFILES_ORIGIN = "git@github.com:{}.git".format(DOTFILES_REPOSITORY)
DOTFILES_TARBALL_URL = "https://github.com/{}/tarball/master".format(DOTFILES_REPOSITORY)
DOTFILES_DIRECTORY = "{}/.dotfiles".format(os.getenv("HOME"))

FILES_TO_SYMLINK = ["gitattributes", "gitignore", "tmux.conf", "vimrc", "zshrc"]

HUB_VERSION = "2.2.9"
PACKAGES = [
    ("macvim --env-std --with-cscope --with-lua --with-override-system-vim", "vim-gnome"),
    ("silversearcher-ag", "the_silver_searcher"),
    ("python", "pyhton-pip")
]
