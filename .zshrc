# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/usr/local/opt/bison/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="/Users/sekin/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#
#
alias gitlogG="git log --color --graph --oneline"



# Virtual env
# export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/Devel
# export VIRTUALENVWRAPPER_PYTHON=$(which python3.10)
# source $(which virtualenvwrapper.sh)




alias dateshort="date +"%Y%m%d""

#[ -f "/Users/sekin/.ghcup/env" ] && source "/Users/sekin/.ghcup/env" # ghcup-env
#if [ -e /Users/sekin/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/sekin/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer




# Alias
alias aux="adaux"
alias sshnv_alpha="ssh nvidia@172.16.1.200"
alias aux_pra_format="aux pra add-copy-right ; aux pra black ; aux pra pycln; aux pra isort "

alias workmono="source /Users/sekin/Project/mono/.venv/bin/activate"
alias workcod="source /Users/sekin/Project/mono-codex/.venv/bin/activate"
alias run_all_servers="workmono ; just run-auth & just run-hub & just run-reader &"

alias cdcodex="cd /Users/sekin/Project/mono-codex"

alias cddec="cd /Users/sekin/Project/mono/projects/devices"
alias cdlino="cd /Users/sekin/Project/mono/projects/lino"
alias cdexp="cd /Users/sekin/Project/mono/projects/experiments"
alias cdapi="cd /Users/sekin/Project/mono/projects/api"
alias cdpost="cd /Users/sekin/Project/mono/projects/postprocess"
alias cdfront="cd /Users/sekin/Project/mono/projects/frontend"
alias cdconfig="cd /Users/sekin/Project/lino-config"
alias cddep="cd /Users/sekin/Project/mono/projects/deploy"
alias cddata="/Users/sekin/lino_data/experiment_test_data"



alias cdcv="/Users/sekin/Project/SideQuest/cv-webpage"
alias cdpravafin="/Users/sekin/Project/SideQuest/pravafin"
alias cdlum="/Users/sekin/Project/SideQuest/LumoRobotic"






export PYTHONDEVMODE=1
export PATH="/Users/sekin/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Project/mono/.venv/bin/python3:$HOME/.venv/nvim/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export VIM_PYTHON3="/Users/sekin/Project/mono/.venv/bin/python3"

# Load secret environment variables (API keys, tokens, etc.)
[ -f "$HOME/.zshrc.secret" ] && source "$HOME/.zshrc.secret"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
