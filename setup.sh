#!/bin/bash

INSTALL_DIR="/usr/local/bin"
COMPLETIONS_DIR="/usr/share/bash-completion/completions"

check_permissions () {
    if ! [ -w $INSTALL_DIR ] || ! [ -w $COMPLETIONS_DIR ]; then
        echo "You do not have permission to write to $INSTALL_DIR/ or $COMPLETIONS_DIR/"
        echo "Run this script again with elevated permissions (perhaps with sudo)."
        exit 0
    fi
}

uninstall () {
    if [ -f "$INSTALL_DIR/notes" ] || [ -f "$COMPLETIONS_DIR/notes" ]; then
        echo "A 'notes' command and/or completions are already installed. Specifically:"
        echo "    $INSTALL_DIR/notes"
        echo "    $COMPLETIONS_DIR/notes"
        while true; do
           read -p "Delete before installing a fresh copy (Y/N)? " choice </dev/tty
           case $choice in
               [Yy]* ) rm -v "$INSTALL_DIR/notes" "$COMPLETIONS_DIR/notes"; echo; break;;
               [Nn]* ) echo "Aborting... Nothing was changed."; exit 0; break;;
               * ) echo "Please answer Yes or No.";;
           esac
        done
    fi
}

do_install () {
    check_permissions
    uninstall
    # get the latest stable version
    echo "Getting the latest stable version..."
    LATEST_TAG=$(curl -s https://api.github.com/repos/pimterry/notes/releases/latest | grep -Po '(?<="tag_name": ")[^"]*')
    echo "Latest stable version: $LATEST_TAG"
    echo
    # install
    echo "installing notes command"
    curl -s "https://cdn.rawgit.com/pimterry/notes/$LATEST_TAG/notes" > "$INSTALL_DIR/notes" && chmod +x "$INSTALL_DIR/notes"

    echo "adding bash completions"
    curl -s "https://cdn.rawgit.com/pimterry/notes/$LATEST_TAG/notes.bash_completion" > "$COMPLETIONS_DIR/notes"
    echo
    echo "installation finished."
    echo "new files created at:"
    echo "    $INSTALL_DIR/notes"
    echo "    $COMPLETIONS_DIR/notes"
}

do_install