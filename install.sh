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
# Get user's home directory so we can dum config later
user_home=$(getent passwd $SUDO_USER | cut -d: -f6)


echo "Checking for Dependencies..."
    assertInstalled bash curl tar

echo "Downloading and Extracting Notes from Repository..."
    extract_dir=$(mktemp -d)
    curl -L https://api.github.com/repos/pimterry/notes/tarball | tar -xzp -C $extract_dir --strip-components=1

# Pre-setup check for bash completion directory
bash_completion_dir=`pkg-config --variable=completionsdir bash-completion` 2>/dev/null

echo "Moving Files into Place..."
    mv $extract_dir/notes /usr/local/bin/notes
    # Make it runnable
    chmod a+x /usr/local/bin/notes
    # Do we have bash completion abilities?
    if [ -d $bash_completion_dir ]; then
        mv $extract_dir/notes.bash_completion $bash_completion_dir/notes
    fi
    mkdir -p $user_home/.config/notes/
    mv $extract_dir/config.example $user_home/.config/notes/config.example

echo "Cleaning Up..."
    rm -rf $extract_dir

echo "All done."
