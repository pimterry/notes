#!./libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

# Set up a directory for our notes
TMP_DIRECTORY=$(mktemp -d)
export NOTES_DIRECTORY="$TMP_DIRECTORY"

notes="./notes"

@test "Should output nothing and return non-zero if there are no notes" {
  run $notes find

  assert_failure
  echo $output
  assert_equal $(echo $output | wc -w) 0 
}

@test "Should show all notes found if no pattern is provided" {
  touch $NOTES_DIRECTORY/note1.md
  touch $NOTES_DIRECTORY/note2.md

  run $notes find
  assert_success
  assert_line "note1.md"
  assert_line "note2.md"
}

@test "Should show matching notes only if a pattern is provided" {
  touch $NOTES_DIRECTORY/match-note1.md
  touch $NOTES_DIRECTORY/hide-note2.md

  run $notes find "match"

  assert_success
  assert_line "match-note1.md"
  refute_line "hide-note2.md"
}

@test "Should match notes case insensitively" {
  touch $NOTES_DIRECTORY/MATCH-note1.md
  touch $NOTES_DIRECTORY/hide-note2.md

  run $notes find "match"

  assert_success
  assert_line "MATCH-note1.md"
  refute_line "hide-note2.md"
}

@test "Should match subdirectory or file names" {
  touch "$NOTES_DIRECTORY/hide-note.md"
  mkdir "$NOTES_DIRECTORY/match-directory"
  touch "$NOTES_DIRECTORY/match-directory/note.md"

  run $notes find "match"

  assert_success
  assert_output "match-directory/note.md"
}

@test "Should find files inside subdirectories with spaces" {
  mkdir "$NOTES_DIRECTORY/path with spaces"
  touch "$NOTES_DIRECTORY/path with spaces/note.md"

  run $notes find

  assert_success
  assert_output "path with spaces/note.md"
}