#!./libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

setup() {
  setupNotesEnv
}

teardown() {
  teardownNotesEnv
}

export EDITOR=touch
notes="./notes"

@test "Should create a new note with the given name" {
  run $notes new note

  assert_success
  assert_exists "$NOTES_DIRECTORY/note.md"
}

@test "Should create new notes within subfolders" {
  run $notes new subfolder/note

  assert_success
  assert_exists "$NOTES_DIRECTORY/subfolder/note.md"
}