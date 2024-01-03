#!./test/libs/bats/bin/bats

load 'helpers'

setup() {
  setupNotesEnv
}

teardown() {
  teardownNotesEnv
}

notes="./notes"

@test "realpath should return notes_dir without a filename" {
  run $notes realpath

  assert_success
  assert_output "$NOTES_DIRECTORY"
}

@test "realpath of non-existing notes should return the future path to the file" {
  run $notes realpath note

  assert_success
  assert_output "$NOTES_DIRECTORY/note.md"
}

@test "realpath of any existing note should return the path to the file" {
  run $notes new note
  run $notes realpath note

  assert_success
  assert_output "$NOTES_DIRECTORY/note.md"
}
