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
  TMP_DIRECTORY=$(mktemp -d)
  export NOTES_DIRECTORY="$TMP_DIRECTORY"

  run $notes open

  assert_success
  assert_output "Opening $NOTES_DIRECTORY"
}

@test "Opens a file passed by pipe if provided" {
  TMP_DIRECTORY=$(mktemp -d)
  export NOTES_DIRECTORY="$TMP_DIRECTORY"
  touch $NOTES_DIRECTORY/note.md

  run bash -c "$notes find | $notes open"

  assert_success
  assert_equal "$(cat $FAKE_TTY)" "Editing $NOTES_DIRECTORY/note.md"
}