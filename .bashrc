##
## Add custom paths
##

PATH=/usr/local/bin:/usr/local/sbin:$PATH
PATH=$PATH:/Users/burleigh/bin
PATH=$PATH:/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin

##
## Misc environment update
##

# fix the shell's encoding: https://github.com/cucumber/gherkin
export LC_CTYPE=en_US.UTF-8
#export LC_CTYPE=C

##
## Aliases
##
alias ss='source ~/.bashrc'

##
## Set the prompt to be the output of ~/bin/prompt.pl
##

PS1='$(/Users/burleigh/bin/prompt.pl)'

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

umask 0022

