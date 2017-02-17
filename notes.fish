# Completion file for notes

complete -c notes -n '__fish_use_subcommand' -xa new --description "Create new note"
complete -c notes -n '__fish_use_subcommand' -xa ls --description "List notes by path"
complete -c notes -n '__fish_use_subcommand' -xa find --description "Search notes by filename and path"
complete -c notes -n '__fish_use_subcommand' -xa grep --description "Search notes by content"
complete -c notes -n '__fish_use_subcommand' -xa search --description "Search notes by filename or content"
complete -c notes -n '__fish_use_subcommand' -xa open --description "Open a note for editing by full name"
complete -c notes -n '__fish_use_subcommand' -xa rm --description "Remove note or folder"

complete -c notes -xs h -l help --description "Print this usage information"
complete -c notes -n 'contains rm (commandline -poc)' -x -s r -l recursive --description "Delete an item recursively"

complete -c notes -n 'contains open (commandline -poc)' -xa  '(cd $NOTES_DIRECTORY)'
complete -c notes -n 'contains new  (commandline -poc)' -xfa '(cd $NOTES_DIRECTORY)'
complete -c notes -n 'contains rm   (commandline -poc)' -xa  '(cd $NOTES_DIRECTORY)'
complete -c notes -n 'contains ls   (commandline -poc)' -xfa '(cd $NOTES_DIRECTORY)'
