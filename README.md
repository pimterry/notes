# notes [![Build Status](https://github.com/pimterry/notes/workflows/CI/badge.svg)](https://github.com/pimterry/notes/actions)
Simple delightful note taking, with none of the lock-in.

[![Asciicast demo](asciicast.gif)](https://asciinema.org/a/2pmdb9vyv71skgwx4r7mlnea8?speed=2&t=1&autoplay=1)

This demo uses zsh, vim and dropbox, but don't panic, that's just me. `notes` will work just fine with whatever other text editor, shell and syncing solution you feel like.

## Why do I want this?

You already have a tool that backs up and syncs your data (be it Dropbox, iCloud, Seafile or whatever). You already have a text editor on your desktop, your laptops, your phone and that tablet you've forgotten about.

You want to take notes.

You could use a web X.0 note taking app that reimplements all of that from scratch (poorly). You could tie yourself to a tool that holds all your data for you in its own brand-new format, locks you into its (often bloated) UI, and then steadily removes features unless you start paying (hey Evernote). You don't have to.

Instead, you could have a simple folder full of simple text files, synced with your sync-thing of choice, edited with your edit-thing of choice. It's easy to understand, easy to use, and accessible from a million other new tools too whenever you next fancy a change. You can do this with little more than windows explorer and notepad, but it's nice to have a specialised tool to add on top and make this a little neater where you can.

**That's where `notes` comes in. Bring your own data syncing, bring your own text editor, put your notes in good old fashioned files, and `notes` will give you a CLI tool to neatly glue it all together.**

This is just one tool in the chain. `notes` is a command line tool, and some people will want a proper UI, or a web interface, or something that works on mobile. You can use this in one place and solve every other step in that chain any other way you like though &mdash; there's no shortage of simple file browsers and text editors that'll get the job done on any platform you like.

## How do I install this?

### Automatic:

```bash
curl -Ls https://raw.githubusercontent.com/pimterry/notes/latest-release/install.sh | sudo bash
```
This will install `notes`, a default configuration, a man page, and bash completion if possible.

```bash
curl -Ls https://raw.githubusercontent.com/pimterry/notes/latest-release/install.sh | PREFIX=$HOME bash
```
For non-root installation(user directory).

### Manual:

Download `notes`, `chmod +x`, put it in your `$path`. This will probably do it:

```bash
curl https://raw.githubusercontent.com/pimterry/notes/latest-release/notes > /usr/local/bin/notes && chmod +x /usr/local/bin/notes
```

#### Installing auto completion

`notes` includes auto completion, to let you tab-complete commands and your note names. This requires Bash > 4.0 and [bash-completion](https://github.com/scop/bash-completion), Zsh, or Fish-shell to be installed - it's probably available from your friendly local package manager.

To enable completion for notes, copy the completion script into your bash, zsh, or fish completion directory, and it should be automatically loaded. The bash completion directory is `/usr/share/bash-completion/completions/` on a typical Debian install, or `/usr/local/etc/bash_completion.d/` on OSX with `bash-completion` from homebrew. The zsh completion directory is `/usr/share/zsh/functions/Completion/` in Linux. The fish completion directory is `~/.config/fish/completions` or `/etc/fish/completions`. You may be able to find your own bash completion directory by running the following command:

    pkg-config --variable=completionsdir bash-completion

Installing the completions might be as follows:

**Bash**

```bash
curl https://raw.githubusercontent.com/pimterry/notes/latest-release/notes.bash_completion > /usr/share/bash-completion/completions/notes
```

**Zsh**

On *buntu based distros and OSX:
```bash
curl -L https://raw.githubusercontent.com/pimterry/notes/latest-release/_notes > /usr/local/share/zsh/site-functions/_notes
```

On other Unix distros:

```bash
curl -L https://raw.githubusercontent.com/pimterry/notes/latest-release/_notes > /usr/share/zsh/site-functions/_notes
```
**Fish**

```fish
curl -L https://raw.githubusercontent.com/pimterry/notes/latest-release/notes.fish > ~/.config/fish/completions/notes.fish
```

You'll need to open a new shell for this to take effect.

## What if I want to uninstall this?
If you used the automated install script to install notes, you can uninstall it the same way, by running:
```bash
curl -L https://raw.githubusercontent.com/pimterry/notes/latest-release/install.sh | bash -s -- uninstall
```

## How do I configure this?

By default your notes live in ~/notes, but you can change that to anywhere you like by setting the `$NOTES_DIRECTORY` environmental variable. See [how do I configure this?](#how-do-i-configure-this) for more details.

To get started with you'll want to set `$EDITOR` to your favourite text editor, and probably `$NOTES_DIRECTORY` to the directory in which you'd like to use to store your notes (this defaults to `~/notes`). You'll typically want to set these as environment variables in your `.bashrc`, `.zshrc`, or similar. Remember to use `export` command when setting environment variables on the command line in Linux.

There are also more complex options available. You can set any configuration properties either in the environment, or in a config file (stored in `~/.config/notes/config`), with settings in config overriding those in your environment. This allows you to configure a different `$EDITOR` for notes to everything else, if you like. The config file is a good choice for more complex set ups, but probably not worth worrying about to start with. We've included an example config in this repo for you ([config](config)) that you can copy if you like.

### What are the configuration options?

* `QUICKNOTE_FORMAT` changes the way that quicknotes are generated. The string formatted using the `date` command.
* `NOTES_EXT` changes the default extension that notes are saved with.
* `TEMPLATES_DIR` changes the directory in which templates are stored.
* `NOTES_DIRECTORY` changes the directory in which notes are stored.
* `EDITOR` can also be overriden here, for `notes` only.
* `POST_COMMAND` sets the command to run after any modification command (e.g. `open`, `mv`, ...) succeeds


## How do I use it?

### `notes new [-t <template-name>] <note-name>`

Opens your `$EDITOR` of choice for a new note, with the given name. The name can include slashes, if you want to put your note in a subfolder. Leave out the name if you want one to be generated for you (e.g. `quicknote-2016-12-21.md` - format configurable with `$QUICKNOTE_FORMAT`). If you want to place a quicknote in a subfolder, use a trailing slash: `notes new subfolder/`. Shorthand alias also available with `notes n`.

If you pass the `-t` flag to `notes new`, the note will be created from a template. The template is a file in your notes directory, with the same name as the template name you pass in. For example, if you have a template called `meeting-notes` in your notes directory, you can create a new note from that template with `notes new -t meeting-notes new-file-name`. This will open your `$EDITOR` with the contents of that template file, and you can edit it and save it as a new note.

If you do not supply an extension in `note-name`, it will be automatically appended with the default file extension (e.g. "newnote" will become "newnote.md"). However, if you include a one-to-four-letter file extension, notes will use that extension when creating the file (e.g. "newnote.tex" is created as "newnote.tex"; not "newnote.md", or "newnote.tex.md").

### `notes find <part-of-a-note-name>`

Searches note filenames and paths for the given string, and returns every single match. If no pattern is specified, this returns every single note. Shorthand alias also available with `notes f`.

### `notes grep <part-of-some-note-content>`

Searches all note content for the given string and returns all the matches. Shorthand alias also available with `notes g`.

### `notes search <part-of-a-note-name-or-note-content>`

Searches all note content and note filenames for the given string and returns all the matches. Shorthand alias also available with `notes s`.

### `notes ls <directory>`

Lists note names and note directories at a single level. Lists all top level notes and directories if no path is provided, or the top-level contents of a directory if one is provided. Automatically ignores hidden files or filenames ending with `~` (Vim backup files).

### `notes open`

Opens your notes folder in your default configured file explorer. Shorthand alias also available with `notes o`.

### `notes open <note-name>`

Opens a given note in your `$EDITOR`. Name can be an absolute path, or a relative path in your notes (.md suffix optional). Shorthand alias also available with `notes o`.

If no file-suffix is given in `note-name`, the notes will attempt to open `note-name.md` (or whatever your default suffix is set to). However, if the note-name is given an suffix, the default suffix will not be appended (e.g. `notes open note-name.txt` will open `note-name.txt`; not `note-name.md` or `note-name.txt.md`).

### `notes append <note-name> [message]`

Appends `message` to the `note-name` note. If this note does not exist, a new note of <note-name> will be created. This command also accepts stdin via piping. An example would be `echo "hello" | notes append <note-name>` Shorthand alias also available with `notes a`.

### `notes mv <note-name> <destination>|<directory>`

Renames a given note to destination or moves the note to directory. Name can be an absolute path, or a relative path in your notes (.md suffix optional). Destination and directory have to be a relative path in your notes.

### `notes rm [-r | --recursive] <note-name>`

Removes the given note if it exists. If `-r` or `--recursive` is given, deletes the folders/notes recursively.

### `notes cat <note-name>`
Displays the note. Shorthand alias also available with `notes c`.

### `notes grep/find <pattern> | notes open`

Combine these together! This opens each matching note in your `$EDITOR` in turn.

## Tell me of the future

All the above works. Here's what's coming next:

- [ ] More interesting and nicer looking file/grep search result formatting, perhaps only when not piping? (https://github.com/pimterry/notes/issues/27)
- [ ] Make the file extension optional (https://github.com/pimterry/notes/issues/24)
- [ ] Interactive mode? `notes` could open a scrollable list of notes, open your editor when you pick one, and reappear after you close it. (https://github.com/pimterry/notes/issues/17)
- [ ] Tree view (https://github.com/pimterry/notes/issues/26)
- [ ] Easy way to see short notes snippets in find/grep/tree? Could be option (`--snippets`) or by piping to a command (`notes find | notes snippets`). Maybe call it `head`? (https://github.com/pimterry/notes/issues/22)
- [ ] Version control - probably by finding an easy (optional) way to integrate this automatically with Git (https://github.com/pimterry/notes/issues/12)

## I want to help

Great! Jump in. Feel free to play around, open an issue with new feature ideas or open PRs for fixes and improvements. Do check with an issue first if you're planning to do anything substantial to avoid disappointment.

Remember that `notes` is intended to be a small toolbox of commands - if it's possible to build your extension as an independent wrapper building on the existing notes commands, that's probably a better first step. Create new functionality on top of `notes` and then file issues to extend `notes` to better support that wrapper, or to merge your wrapper in as a built-in command later, once you're sure it works and it's useful.

If you want to get the code locally you'll need to:

```bash
git clone <your fork>
git submodule update --init --recursive
./test.sh # Check the tests work before you make any changes
```

If you install [`entr`](http://entrproject.org/) you can also run `./dev.sh`, which will watch all files within the project directory, and rerun tests any time they change.

If you submit a PR, please make sure it:

* Doesn't break any existing tests
* Adds new tests, if appropriate
* Adds new documentation, if appropriate

### Release process

To build a new release of `notes`:

* `export NEW_VERSION="X.Y.Z"` (replacing X.Y.Z with the appropriate new version)
* Run:
    ```
    # Update the version number in the source
    sed -i -e "s/notes_version=.*/notes_version=\"$NEW_VERSION\"/g" notes

    # Commit, tag & push the new version
    git add notes
    git commit -m $NEW_VERSION
    git tag $NEW_VERSION
    git push origin master --tags

    # Mark this version as the latest release
    git checkout -B latest-release
    git push --force origin latest-release
    git checkout -
    ```
