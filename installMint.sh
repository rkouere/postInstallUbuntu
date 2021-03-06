#!/bin/bash
update="aptitude update"
install="aptitude -y install"

function displayFunctionName {
	echo "========== ${FUNCNAME[ 1 ]} =========="

}

function displayHelp {
	echo "help"

}


# check that a program exists. If not, it installs it
function checkProg {
    if command -v $1 2>/dev/null; then
        echo "$1 is installed... keep on going"
    else
        echo "$1 is not installed. We are going to install it"
        $install $1
    fi
}

# file manager that I prefer to nautilus
function installPcmanfm {
    aptitude install pcmanfm
}

function setProxy {
	displayFunctionName
echo '
http_proxy="http://proxy.univ-lille1.fr:3128/"
https_proxy="http://proxy.univ-lille1.fr:3128/"
ftp_proxy="http://proxy.univ-lille1.fr:3128/"
no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
HTTP_PROXY="http://proxy.univ-lille1.fr:3128/"
HTTPS_PROXY="http://proxy.univ-lille1.fr:3128/"
FTP_PROXY="http://proxy.univ-lille1.fr:3128/"
NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
' >> /etc/environment

echo '
Acquire::http::proxy "http://proxy.univ-lille1.fr:3128/";
Acquire::ftp::proxy "http://proxy.univ-lille1.fr:3128/";
Acquire::https::proxy "http://proxy.univ-lille1.fr:3128/";
' > /etc/apt/apt.conf.d/95proxies


}
function installGit {
	displayFunctionName
	$install git
}


function updateMint {
	displayFunctionName
	$update
	aptitude upgrade
}

# https://github.com/scrooloose/syntastic
function installSyntastic {
    # Install pathogen.vim
    aptitude install python3-flake8
    checkProg curl
    sudo -u $SUDO_USER mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    sudo -u $SUDO_USER curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    sudo -u $SUDO_USER echo "execute pathogen#infect()" >> ~/.vimrc
    # Install syntastic as a Pathogen bundle
    cd ~/.vim/bundle && \
    checkProg git
    sudo -u $SUDO_USER git clone https://github.com/scrooloose/syntastic.git
    
    sudo -u $SUDO_USER echo "
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    " >> ~/.vimrc
}


function installVim {
	displayFunctionName
	$install vim
	sudo -u $SUDO_USER echo "
    filetype plugin indent on
    set tabstop=4
    set shiftwidth=4
    set expandtab
    
    
    " >> ~/.vimrc
    installSyntastic
}

function installOwnCloudClient {
	displayFunctionName
	sudo -u $SUDO_USER sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud-client.list"
    sudo -u $SUDO_USER wget http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_14.04/Release.key
	apt-key add - < Release.key  
	sudo -u $SUDO_USER rm Release.key
	$update
	$install owncloud-client
}


# installs the latest zsh, oh my zsh, change the theme and makes it the default terminal
function installZsh {
	displayFunctionName
	sudo -u $SUDO_USER cd
	$install zsh
    #we need git to install oh my zsh
    checkProg git

    sudo -u $SUDO_USER sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
 	
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="bira"/g' ~/.zshrc
	# make zsh the default theme
	sudo -u $SUDO_USER chsh -s /bin/zsh
}


function installAwesome {
	displayFunctionName

	echo `add-apt-repository -y ppa:klaus-vormweg/awesome`
        $update
        $install awesome awesome-extra
        installPcmanfm
}


# installs the rc.lua.multicolor theme
function awesomeCopycats {
	displayFunctionName

	cd /tmp
	mkdir awesomeThemes
	cd awesomeThemes
	# download themes
	wget https://github.com/copycat-killer/awesome-copycats/archive/master.zip
	unzip master.zip
	rm -f master.zip
	# download lain (doesn't work at uni)
	wget https://github.com/copycat-killer/lain/archive/master.zip
	unzip master.zip
	rm master.zip
	cp -r lain-master/* awesome-copycats-master/lain 

	
	sudo -u $SUDO_USER mkdir ~/.config/awesome
	sudo -u $SUDO_USER cp -r awesome-copycats-master/* ~/.config/awesome
	cd ~/.config/awesome
	sudo -u $SUDO_USER cp rc.lua.multicolor rc.lua
	#by default this theme uses terminals not installed on Mint. Let's change that.
	sed -i 's/terminal   = "urxvtc" or "xterm"/terminal   = "x-terminal-emulator"/g' rc.lua
    sed -i 's/awful\.key({ altkey }, "Left",/--awful.key({ altkey }, "Left",/g' rc.lua
    sed -i 's/awful\.key({ altkey }, "Right",/--awful.key({ altkey }, "Right",/g' rc.lua
    sed -i 's/names = { "web", "term", "docs", "media", "files", "other" },/names = { "web", "term", "mails", "media", "files", "other" },/g' rc.lua
    echo 'awful.util.spawn("owncloud")' >> rc.lua
    # key binding for lock and sleep
	sed -i 's/globalkeys = awful\.util\.table\.join(/globalkeys = awful.util.table.join(\nawful.key({ altkey, "Control" }, "l", function () awful.util.spawn("gnome-screensaver-command --lock") end),/g' rc.lua
    sed -i 's/-- Take a screenshot/awful.key({ altkey, "Control" }, "s", function () os\.execute("gnome-screensaver-command --lock \&\& dbus-send --system --print-reply --dest=org\.freedesktop\.UPower \/org\/freedesktop\/UPower org\.freedesktop\.UPower\.Suspend") end),\n-- Take a screenshot/g' rc.lua
}

function installNfs {
	displayFunctionName
	$install nfs-common
	chmod 644 /etc/exports
	/etc/init.d/nfs-kernel-server stop
	/etc/init.d/nfs-kernel-server start


}

function installLocate {
	displayFunctionName
	$install locate
	updatedb
}

function installRedShift {
	displayFunctionName
	$install gtk-redshift
}

# installs various little tools I like + add my bash alias
function installVariousStuff {
	displayFunctionName
    $install tree
    installRedShift
    echo '
        alias g="git"
        alias ga="git add"
        alias gc="git commit -m"
        alias gs="git status"
        alias gd="git diff"


    ' >> ~/.zshrc
}

function main {
	updateMint
	installGit
	installVim
    installOwnCloudClient
	installLocate    	
    installNfs
	installZsh
	installRedshift
}

function usage {
    echo "
    usage: $0 options

    This script will install all the things I like in a machine or special things needing some setup
    OPTIONS:
    [none]  Shows the help message
    -A      Full install (without proxy) 
    -h      Show this message
    -p      Set the proxy
    -v      Installs vim
    -o      Installs the latest Owncloud client   
    -z      Installs zsh with oh my zsh
    -a      Installs the latest awesome
    -c      Installs awesome copycats    
    -n      Installs the nfs tools
    -s      Installs my prefered tools/settings
    -S      Installs syntastic (parser for vim)
    "
}




if [ -z "$1" ]
  then
    usage
  else
    while getopts “AShpvozacns” OPTION
    do
        case $OPTION in
            A)
                main
                ;;
            S)    
                installSyntastic
                ;;
            h)
                usage
                exit 1
                ;;
            p)
                setProxy
                ;;
            v)
               installVim 
                ;;
            o)
                installOwnCloudClient
                ;;
            z)
                installZsh   
                ;;
            a)
                installAwesome   
                ;;
            c)
                awesomeCopycats   
                ;;
            n)
                installNfs   
                ;;
            s)
                installVariousStuff  
                ;;
            ?)
                usage
                exit
                ;;
        esac
    done 	
fi

