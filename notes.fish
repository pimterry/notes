# Notes completion file for fish shell <https://github.com/pimterry/notes>
# Place in ~/.config/fish/completions/

# Set some useful local variables
## lists of commands used by notes
set -l notes_list_commands o open mv rm cat
set -l notes_friendly_commands new open find ls rm cat mv grep
set -l notes_commands n new ls find f grep g search s open o mv rm cat append a
set -l notes_dir_commands n new grep ls

# NOTES_DIRECTORY
## use NOTES_DIRECTORY variable if set else...
if not set -q NOTES_DIRECTORY
    ## if config file exists, read it
    if test -e $HOME/.config/notes/config
        set NOTES_DIRECTORY (string split = (grep "NOTES_DIRECTORY" $HOME/.config/notes/config))[2]
    end
end
## in case of failure, use default notes dir
if not set -q NOTES_DIRECTORY[1]
    set NOTES_DIRECTORY "$HOME/notes"
end

# FILE COMPLETIONS
complete -c notes -f
complete -c notes -n "not __fish_seen_subcommand_from $notes_commands" -a "$notes_friendly_commands"
complete -c notes -n "__fish_seen_subcommand_from $notes_list_commands" -a "(notes find|grep -v '~\$'|sed 's/[.]md\$//')"
complete -c notes -n "__fish_seen_subcommand_from $notes_dir_commands" -a "(find $NOTES_DIRECTORY -type d -printf '%P/\n')"
