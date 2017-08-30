#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

setup() {
  setupNotesEnv
}

teardown() {
  teardownNotesEnv
}

notes="./notes"

@test "Should show created note" {
  echo line1 >> "$NOTES_DIRECTORY/note.md"
  echo line2 >> "$NOTES_DIRECTORY/note.md"
  run $notes cat note.md

  assert_success
  assert_output $'line1\nline2'
}

@test "Accepts names without .md to show" {
  echo line1 >> "$NOTES_DIRECTORY/note.md"
  echo line2 >> "$NOTES_DIRECTORY/note.md"
  run $notes cat note

  assert_success
  assert_output $'line1\nline2'
}

@test "Should fail to show non-existent note" {
  run $notes cat note

  assert_failure
}

@test "Accepts relative notes paths to show" {
  echo line1 >> "$NOTES_DIRECTORY/note.md"
  echo line2 >> "$NOTES_DIRECTORY/note.md"
  run $notes cat $NOTES_DIRECTORY/note.md

  assert_success
  assert_output $'line1\nline2'
}

@test "Show a file passed by pipe from find" {
  echo line1 >> "$NOTES_DIRECTORY/note.md"
  echo line2 >> "$NOTES_DIRECTORY/note.md"

  run bash -c "$notes find | $notes cat"

  assert_success
  assert_output $'line1\nline2'
}

@test "Show multiple files passed by pipe from find" {
  echo line1 >> "$NOTES_DIRECTORY/note.md"
  echo line2 >> "$NOTES_DIRECTORY/note2.md"

  run bash -c "$notes find | $notes cat"

  assert_success
  assert_output $'line1\nline2'
}

@test "Should complain and ask for a name if one is not provided to show" {
  run $notes cat

  assert_failure
  assert_line "Cat requires a name, but none was provided."
}
