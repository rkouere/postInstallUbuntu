# postInstallUbuntu

This script aims at reducing installing all the packages I like to have on an Ubuntu/Debian based distrib.

It has two modes : full install or on a single package basis.

The full install will install :
* pcmanfm
* git
* vim (and add some options to the vimrc)
* latest owncloud client
* latest awesome wm
* awesome copycats themes (and tailor the theme as I like it)
* nfs
* locate 
* xscreensaver (with awesome tunning : lock screen of F12 + autostart)

Custom install
    * OPTIONS:
    * [none]  Shows the help message
    * -A      Full install (without proxy) 
    * -h      Show this message
    * -p      Set the proxy
    * -v      Installs vim
    * -o      Installs the latest Owncloud client   
    * -z      Installs zsh with oh my zsh
    * -a      Installs the latest awesome
    * -c      Installs awesome copycats    
    * -n      Installs the nfs tools
