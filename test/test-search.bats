#!./libs/bats/bin/bats

load 'helpers'

setup() {
  setupNotesEnv
}

teardown() {
  teardownNotesEnv
}

notes="./notes"

@test "Should output nothing and return non-zero if there are no notes to search" {
  run $notes search

  assert_failure
  echo $output
  assert_equal $(echo $output | wc -w) 0
}

@test "Should show all notes found if no pattern is provided to search" {
  touch $NOTES_DIRECTORY/note1.md
  touch $NOTES_DIRECTORY/note2.md

  run $notes search
  assert_success
  assert_line "note1.md"
  assert_line "note2.md"
}

@test "Should search notes when using the search shorthand alias" {
  touch $NOTES_DIRECTORY/note.md

  run $notes s
  assert_success
  assert_line "note.md"
}

@test "Should show matching notes only if a pattern is provided to search" {
  touch $NOTES_DIRECTORY/match-note1.md
  touch $NOTES_DIRECTORY/hide-note2.md

  run $notes search "match"

  assert_success
  assert_line "match-note1.md"
  refute_line "hide-note2.md"
}

@test "Should match notes case insensitively with search" {
  touch $NOTES_DIRECTORY/MATCH-note1.md
  touch $NOTES_DIRECTORY/hide-note2.md

  run $notes search "match"

  assert_success
  assert_line "MATCH-note1.md"
  refute_line "hide-note2.md"
}

@test "Should match subdirectory or file names with search" {
  touch "$NOTES_DIRECTORY/hide-note.md"
  mkdir "$NOTES_DIRECTORY/match-directory"
  touch "$NOTES_DIRECTORY/match-directory/note.md"

  run $notes search "match"

  assert_success
  assert_output "match-directory/note.md"
}

# These are the 'grep' tests.

@test "Should match only the files containing the given pattern when searching" {
  echo "my-pattern" > $NOTES_DIRECTORY/matching-note.md
  echo "some-other-pattern" > $NOTES_DIRECTORY/non-matching-note.md

  run $notes search my-pattern

  assert_success
  assert_line "matching-note.md"
  refute_line "non-matching-note.md"
}

@test "Should search notes when using the search shorthand alias" {
  echo "my-pattern" > $NOTES_DIRECTORY/matching-note.md

  run $notes s my-pattern

  assert_success
  assert_line "matching-note.md"
}

@test "Should search case-insensitively" {
  echo "LETTERS" > $NOTES_DIRECTORY/matching-note.md

  run $notes search letter

  assert_success
  assert_line "matching-note.md"
}

@test "Should search files with paths including spaces" {
  mkdir "$NOTES_DIRECTORY/path with spaces"
  echo 'match' > "$NOTES_DIRECTORY/path with spaces/note file.md"

  run $notes search match

  assert_success
  assert_output "path with spaces/note file.md"
}
