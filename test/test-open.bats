#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

function open() { echo "Opening $*"; }
export -f open

function edit() { echo "Editing $*"; }
export -f edit
export EDITOR="edit"

setup() {
  setupNotesEnv
}

teardown() {
  teardownNotesEnv
}

notes="./notes"

@test "Opens the default notes directory if not configured" {
  unset NOTES_DIRECTORY
  run $notes open

  assert_success
  assert_output "Opening $HOME/notes" 
}

@test "Opens the configured notes directory if set" {
  run $notes open

  assert_success
  assert_output "Opening $NOTES_DIRECTORY"
}

@test "Opens a file passed by pipe from find" {
  touch $NOTES_DIRECTORY/note.md

  run bash -c "$notes find | $notes open"

  assert_success
  assert_output "Editing $NOTES_DIRECTORY/note.md"
}

@test "Opens a file passed by pipe from grep" {
  echo "hi" > $NOTES_DIRECTORY/note.md

  run bash -c "$notes grep 'hi' | $notes open"

  assert_success
  assert_output "Editing $NOTES_DIRECTORY/note.md"
}

@test "Opens a file passed by pipe when using the shorthand open alias" {
  touch $NOTES_DIRECTORY/note.md

  run bash -c "$notes find | $notes o"

  assert_success
  assert_output "Editing $NOTES_DIRECTORY/note.md"
}

@test "Opens multiple files passed by pipe from find" {
  touch $NOTES_DIRECTORY/note.md
  touch $NOTES_DIRECTORY/note2.md

  run bash -c "$notes find | $notes open"

  assert_success
  assert_line "Editing $NOTES_DIRECTORY/note2.md $NOTES_DIRECTORY/note.md"
}

@test "Accepts relative notes paths to open" {
  touch $NOTES_DIRECTORY/note.md

  run bash -c "$notes open note.md"

  assert_success
  assert_output "Editing $NOTES_DIRECTORY/note.md"
}

@test "Accepts names without .md to open" {
  touch $NOTES_DIRECTORY/note.md

  run bash -c "$notes open note"

  assert_success
  assert_output "Editing $NOTES_DIRECTORY/note.md"
}

@test "Uses 'editor' if \$EDITOR is not available" {
  unset EDITOR
  # Simulate a `editor` symlink (as in Debian/Ubuntu/etc)
  function editor() { echo "Editor bin, editing $*"; }
  export -f editor

  run bash -c "$notes open note.md"

  assert_success
  assert_output "Editor bin, editing $NOTES_DIRECTORY/note.md"
}

@test "Uses \$EDITOR over 'editor' if both are available" {
  # Simulate a `editor` symlink (as in Debian/Ubuntu/etc)
  function editor() { echo "Editor bin, editing $*"; }
  export -f editor

  run bash -c "$notes open note.md"

  assert_success
  assert_output "Editing $NOTES_DIRECTORY/note.md"
}

@test "Exits if \$EDITOR isn't set and 'editor' doesn't exist" {
  unset EDITOR
  function type() { [ $1 != "editor" ]; } # Pretend editor doesn't exist.
  export -f type

  run $notes open test

  assert_failure
  assert_output "Please set \$EDITOR to edit notes"
}
