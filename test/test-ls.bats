#!./test/libs/bats/bin/bats

load 'helpers'

setup() {
  setupNotesEnv
}

teardown() {
  teardownNotesEnv
}

notes="./notes"

@test "Should display the templates folder when no notes are present" {
  run $notes ls

  assert_success
  echo $output
  assert_equal $(echo $output | wc -w) 1
}

@test "Should list all notes in notes directory if no pattern is provided to find" {
  touch $NOTES_DIRECTORY/note1.md
  touch $NOTES_DIRECTORY/note2.md

  run $notes ls
  assert_success
  assert_line "note1.md"
  assert_line "note2.md"
}

@test "Should not list temporary files" {
  touch $NOTES_DIRECTORY/note1.md
  touch $NOTES_DIRECTORY/note1.md~
  touch $NOTES_DIRECTORY/note2~with~tilde.md

  run $notes ls
  assert_success

  assert_line "note1.md"
  assert_line "note2~with~tilde.md"

  refute_line "note1.md~"
}

@test "Should list subdirectories with trailing slash" {
  touch $NOTES_DIRECTORY/match-note1.md
  mkdir $NOTES_DIRECTORY/match-dir

  run $notes ls

  assert_success
  assert_line "match-note1.md"
  assert_line "match-dir/"
}

@test "Should not list contents of subdirectories without pattern" {
  touch $NOTES_DIRECTORY/match-note1.md
  mkdir $NOTES_DIRECTORY/match-dir
  touch $NOTES_DIRECTORY/match-dir/hide-note.md

  run $notes ls

  assert_success
  assert_line "match-note1.md"
  assert_line "match-dir/"
  refute_line "hide-note.md"
}

@test "Should list contents of subdirectory given in pattern" {
  touch $NOTES_DIRECTORY/hide-note.md
  mkdir $NOTES_DIRECTORY/match-dir
  touch $NOTES_DIRECTORY/match-dir/match-note1.md

  run $notes ls match-dir

  assert_success
  refute_line "hide-note.md"
  refute_line "match-dir/"
  assert_line "match-dir/match-note1.md"
}

@test "Should list contents of a subdirectory if the pattern includes slashes" {
  mkdir -p $NOTES_DIRECTORY/match-dir/child-dir
  touch $NOTES_DIRECTORY/match-dir/child-dir/match-note1.md

  run $notes ls match-dir/child-dir/

  assert_success
  assert_line "match-dir/child-dir/match-note1.md"
}

