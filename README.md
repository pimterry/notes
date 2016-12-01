# notes [![Travis Build Status](https://img.shields.io/travis/pimterry/notes.svg)](https://travis-ci.org/pimterry/notes)
Simple delightful command-line note taking

## Why do I want this?

You already have a tool that backs up and syncs your data (be it Dropbox, iCloud, Seafile or whatever). You already have a text editor on your desktop, your laptops, your phone and that tablet you've forgotten about. You want to take notes on these myriad fancy boxes.

You could use a web X.0 note taking app that reimplements all of that from scratch (poorly). You could tie yourself to a tool that holds all your data for you in its own brand-new format, locks you into its (often bloated) UI, and then steadily removes features unless you start paying (hey Evernote). You don't have to.

Instead, you could have a simple folder full of simple text files, synced with your sync-thing of choice, edited with your edit-thing of choice. It's easy to understand, easy to use, and accessible from a million other new tools too whenever you next fancy a change. You can do this with little more than windows explorer and notepad, but it's nice to have a specialised tool to add on top and make this a little neater where you can.

**That's where `notes` comes in. Bring your own data syncing, bring your own text editor, put your notes in good old fashioned files, and `notes` will give you a CLI tool to neatly glue it all together.**

This is just one tool in the chain. `notes` is a command line tool, and some people will want a proper UI, or a web interface, or something that works on mobile. You can use this in one place and solve every other step in that chain any other way you like though &mdash; there's no shortage of simple file browsers and text editors that'll get the job done on any platform you like.

## How do I install this?

Download `notes`, `chmod +x`, put it in your `$path`. This will probably do it:

```
curl https://cdn.rawgit.com/pimterry/notes/v0.1.0/notes > /usr/local/bin/notes
``` 

By default your notes live in ~/notes, but you can change that to anywhere you like by setting the `$NOTES_DIRECTORY` environmental variable.

## How do I use it?

```
notes new <note-name>
```

Opens your `$EDITOR` of choice for a new note, with the given name. The name can include slashes, if you want put your note in a subfolder.

```
notes find <part-of-a-note's-name>
```

Searches note filenames and paths for the given string, and returns all the matches.

```
notes grep <part-of-a-note's-content>
```

Searches all note content for the given string and returns all the matches.

```
notes open
```

Opens your notes folder in your default configured file explorer.

```
notes open <note-name>
```

Opens a given note in your `$EDITOR`. Name can be an absolute path, or a relative path in your notes (.md suffix optional).

```
notes grep/find <pattern> | notes open
```

Combine these together! This opens each matching note in your `$EDITOR` in turn.

## Tell me of the future

All the above works. Here's what's coming next:

- [ ] Combining find and grep, to match anything one
- [ ] More interesting and nicer looking file/grep search result formatting (...only when not piping?)
- [ ] Make the file extension optional
- [ ] Bash/zsh command autocompletion
- [ ] Bash/zsh note name autocompletion
- [ ] Shorthand aliases `notes o`, `notes g`, `notes n`
- [ ] Interactive mode? `notes` could open a scrollable list of notes, open your editor when you pick one, and reappear after you close it.

## I want to help

Great! Jump in. Feel free to play around, open an issue with new feature ideas or open PRs for fixes (although check with an issue first if you want to do anything substantial).

If you want to get the code locally you'll need to:

```bash
git clone <your fork>
git submodule update --init --recursive
./test.sh # Check the tests work before you make any changes
```

If you submit a PR, please make sure it:

* Doesn't break existing tests
* Adds new tests, if appropriate
* Adds new documentation, if appropriate