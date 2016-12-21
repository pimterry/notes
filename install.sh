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
    assertInstalled bash curl tar mktemp

# Variable Definitions go here. 
user_home=`eval echo ~$SUDO_USER`
bash_completion_dir=`pkg-config --variable=completionsdir bash-completion 2>/dev/null`
extract_dir=$(mktemp -d /tmp/notes.XXXXX)

echo "Downloading and Extracting Notes from Repository..."
    curl -L https://api.github.com/repos/pimterry/notes/tarball | tar -xzp -C $extract_dir --strip-components=1

echo "Moving Files into Place..."
    mv $extract_dir/notes /usr/local/bin/notes
    # Make it runnable
    # Do we have bash completion abilities?
    if [ -d $bash_completion_dir ]; then
        mv $extract_dir/notes.bash_completion $bash_completion_dir/notes
    fi
    mkdir -p $user_home/.config/notes/
    mv $extract_dir/config.example $user_home/.config/notes/config.example

echo "Fixing Permissions..."
    chown -R $SUDO_USER $user_home/.config/notes 
    chmod a+x /usr/local/bin/notes

echo "Cleaning Up..."
    rm -rf $extract_dir
echo "All done."
