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

# Pre-setup check for bash completion directory
bash_completion_dir=`pkg-config --variable=completionsdir bash-completion` 2>/dev/null

# Yay, Echo self documents! :D
echo "Checking for root..."
    [ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

echo "Checking for Dependencies..."
    assertInstalled bash curl tar

echo "Downloading and Extracting Notes from Repository..."
    extract_dir=$(mktemp -d)
    curl -L https://api.github.com/repos/pimterry/notes/tarball | tar -xzp -C $extract_dir --strip-components=1

echo "Moving Files into Place..."
    mv "$extract_dir"/notes /usr/local/bin/notes
    # Make it runnable
    chmod a+x /usr/local/bin/notes
    # Do we have bash completion abilities?
    if [ -d "$bash_completion_dir" ]; then
        mv "$extract_dir"/notes.bash_completion "$bash_completions_dir"/notes
    fi
    mkdir -p ~/.config/notes/
    mv "$extract_dir"/config.example ~/.config/notes/config.example

echo "Cleaning Up..."
    rm -rf $extract_dir

echo "All done."
