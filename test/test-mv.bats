#!./test/libs/bats/bin/bats

load 'helpers'

setup() {
  setupNotesEnv
}

teardown() {
  teardownNotesEnv
}

export EDITOR=touch
notes="./notes"

@test "Should rename a note" {
  run $notes new note
  run $notes mv note note2

  assert_success
  assert_exists "$NOTES_DIRECTORY/note2.md"
}

@test "Should rename a note in a subdir" {
  run $notes new subdir/note
  run $notes mv subdir/note subdir/note2

  assert_success
  assert_exists "$NOTES_DIRECTORY/subdir/note2.md"
}

@test "Should rename a note with extension" {
  run $notes new note
  run $notes mv note.md note2.md

  assert_success
  assert_exists "$NOTES_DIRECTORY/note2.md"
}

@test "Should move a note to an existing subdir" {
  run $notes new subdir/note
  run $notes new note2
  run $notes mv note2 subdir

  assert_success
  assert_exists "$NOTES_DIRECTORY/subdir/note.md"
  assert_exists "$NOTES_DIRECTORY/subdir/note2.md"
}

@test "Should move a note to a new subdir" {
  run $notes new note
  run $notes mv note.md subdir/note.md

  assert_success
  assert_exists "$NOTES_DIRECTORY/subdir/note.md"
}

@test "Should move a note to notes_directory" {
  run $notes new subdir/note
  run $notes mv subdir/note /

  assert_success
  assert_exists "$NOTES_DIRECTORY/note.md"
}
