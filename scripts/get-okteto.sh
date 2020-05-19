#!/bin/sh

{ # Prevent execution if this script was only partially downloaded

set -e

green="\033[32m"
red="\033[31m"
reset="\033[0m"
install_dir='/usr/local/bin'
install_path='/usr/local/bin/okteto'
OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')
cmd_exists() {
	command -v "$@" > /dev/null 2>&1
}

latestURL=https://github.com/fearoffish/okteto/releases/latest/download

case "$OS" in
    darwin) 
      URL=${latestURL}/okteto-Darwin-x86_64
      ;;
    linux)
      case "$ARCH" in
        x86_64) 
            URL=${latestURL}/okteto-Linux-x86_64
            ;;
        amd64) 
            URL=${latestURL}/okteto-Linux-x86_64
            ;;
        arm) 
            URL=${latestURL}/okteto-Linux-arm
            ;;
        armv8*) 
            URL=${latestURL}/okteto-Linux-arm64
            ;;
        aarch64)
            URL=${latestURL}/okteto-Linux-arm64
            ;;
        *) 
            printf "$red> The architecture (${ARCH}) is not supported by this installation script.$reset\n" 
            exit 1 
            ;;
      esac
      ;;
    *)
      printf "$red> The OS (${OS}) is not supported by this installation script.$reset\n"
      exit 1
      ;;
esac

sh_c='sh -c'
if [ ! -w "$install_dir" ]; then
    # use sudo if $user doesn't have write access to the path
    if [ "$user" != 'root' ]; then
        if cmd_exists sudo; then
            sh_c='sudo -E sh -c'
	elif cmd_exists su; then
            sh_c='su -c'
	else
            echo 'This script requires to run commands as sudo. We are unable to find either "sudo" or "su".'
            exit 1
	fi
    fi
fi

printf "> Downloading $URL\n"
download_path=$(mktemp)
curl -fSL "$URL" -o "$download_path"
chmod +x "$download_path"

printf "> Installing $install_path\n"
$sh_c "mv -f $download_path $install_path"

printf "$green> Okteto successfully installed!\n$reset"

} # End of wrapping
