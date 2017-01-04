#!/bin/sh

# This is an install script for notes

function assertInstalled() {
    for var in "$@"; do
        if ! which $var &> /dev/null; then
            echo "$var is required but not installed, exiting."
            exit 1
        fi
    done
}

# Yay, Echo self documents! :D
echo "Checking for root..."
    [ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

# Make sure we have everything actually installed that we need to install this.
echo "Checking for Dependencies..."
    assertInstalled bash curl tar mktemp install make

# Variable Definitions go here. 
user_home=`eval echo ~$SUDO_USER`
bash_completion_dir=`pkg-config --variable=completionsdir bash-completion 2>/dev/null`
extract_dir=$(mktemp -d /tmp/notes.XXXXX)

echo "Downloading and Extracting Notes from Repository..."
    curl -L https://api.github.com/repos/pimterry/notes/tarball | tar -xzp -C $extract_dir --strip-components=1
echo "Installing notes..."
    cd $extract_dir && make USERDIR=$user_home
echo "Cleaning Up..."
    rm -rf $extract_dir
echo "All done."
