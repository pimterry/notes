# notes [![Travis Build Status](https://img.shields.io/travis/pimterry/notes.svg)](https://travis-ci.org/pimterry/notes)
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

Download `notes`, `chmod +x`, put it in your `$path`. This will probably do it:

```bash
curl https://cdn.rawgit.com/pimterry/notes/v0.2.0/notes > /usr/local/bin/notes && chmod +x /usr/local/bin/notes
```

By default your notes live in ~/notes, but you can change that to anywhere you like by setting the `$NOTES_DIRECTORY` environmental variable.

#### Installing auto completion

`notes` includes auto completion, to let you tab-complete commands and your note names. This requires Bash > 4.0 and [bash-completion](https://github.com/scop/bash-completion) or Zsh to be installed - it's probably available from your friendly local package manager.

To enable completion for notes, copy the completion script into your bash or zsh completion directory, and it should be automatically loaded. The bash completion directory is `/usr/share/bash-completion/completions/` on a typical Debian install, or `/usr/local/etc/bash_completion.d/` on OSX with `bash-completion` from homebrew. The zsh completion directory is `/usr/share/zsh/functions/Completion/` in Linux. You may be able to find your own bash completion directory by running the following command:

    pkg-config --variable=completionsdir bash-completion

Installing the completions might be as follows:

Bash
```bash
curl https://cdn.rawgit.com/pimterry/notes/v0.2.0/notes.bash_completion > /usr/share/bash-completion/completions/notes
```

Zsh
```bash
curl https://cdn.rawgit.com/pimterry/notes/v0.2.0/notes._notes > /usr/share/zsh/functions/Completion/
```

You'll need to open a new shell for this to take effect.

## How do I configure this?

You can set your favourite text editor and your notes directory by setting the `$EDITOR` and `$NOTES_DIRECTORY` environmental variables.

Most users shouldn't need to do any more than that. If you're doing anything more complicated though, you can configure `notes` config directly in "~/.config/notes/config", including EDITOR and NOTES_DIRECTORY. We've included an example in this repo for you ([config.example](config.example)) that you can copy. Any values set in the config file override values in environment variables.

Right now this mainly exists in case you want to use a different `EDITOR` for notes than the one you have set in your environment generally, but this is where all other config will be living in future.

## How do I use it?

### `notes new <note-name>`

Opens your `$EDITOR` of choice for a new note, with the given name. The name can include slashes, if you want to put your note in a subfolder. Shorthand alias also available with `notes n`.

### `notes find <part-of-a-note-name>`

Searches note filenames and paths for the given string, and returns every single match. If no pattern is specified, this returns every single note. Shorthand alias also available with `notes f`.

### `notes grep <part-of-some-note-content>`

Searches all note content for the given string and returns all the matches. Shorthand alias also available with `notes g`.

### `notes ls <directory>`

Lists note names and note directories at a single level. Lists all top level notes and directories if no path is provided, or the top-level contents of a directory if one is provided.

### `notes open`

Opens your notes folder in your default configured file explorer. Shorthand alias also available with `notes o`.

### `notes open <note-name>`

Opens a given note in your `$EDITOR`. Name can be an absolute path, or a relative path in your notes (.md suffix optional). Shorthand alias also available with `notes o`.

### `notes rm [-r | --recursive] <note-name>`

Removes the given note if it exists. If `-r` or `--recursive` is given, deletes the folders/notes recursively.

### `notes grep/find <pattern> | notes open`

Combine these together! This opens each matching note in your `$EDITOR` in turn.

## Tell me of the future

All the above works. Here's what's coming next:

- [ ] Combining find and grep, to match either one (https://github.com/pimterry/notes/issues/16)
- [ ] More interesting and nicer looking file/grep search result formatting, perhaps only when not piping? (https://github.com/pimterry/notes/issues/27)
- [ ] Make the file extension optional (https://github.com/pimterry/notes/issues/24)
- [ ] zsh command and note name autocompletion (https://github.com/pimterry/notes/issues/25)
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
