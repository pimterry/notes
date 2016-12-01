#!./libs/bats/bin/bats

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

@test "Opens a file passed by pipe if provided" {
  touch $NOTES_DIRECTORY/note.md

  run bash -c "$notes find | $notes open"

  assert_success
  assert_output "Editing $NOTES_DIRECTORY/note.md"
}

@test "Opens multiple files passed by pipe if provided" {
  touch $NOTES_DIRECTORY/note.md
  touch $NOTES_DIRECTORY/note2.md

  run bash -c "$notes find | $notes open"

  assert_success
  assert_line "Editing $NOTES_DIRECTORY/note.md"
  assert_line "Editing $NOTES_DIRECTORY/note2.md"
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