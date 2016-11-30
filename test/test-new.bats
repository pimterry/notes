#!./libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

# Set up a directory for our notes
TMP_DIRECTORY=$(mktemp -d)
export NOTES_DIRECTORY="$TMP_DIRECTORY"
export EDITOR=touch

notes="./notes"

@test "Should create a new note with the given name" {
  run $notes new note

  assert_success
  assert_exists "$NOTES_DIRECTORY/note.md"
}

@test "Should create a new note with the given name, using 'n' alias" {
  run $notes n note

  assert_success
  assert_exists "$NOTES_DIRECTORY/note.md"
}