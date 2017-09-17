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

@test "Should complain and ask for a pattern if not is provided to grep" {
  run $notes -s grep

  assert_failure
  assert_line "Grep requires a pattern, but none was provided."
}

@test "Should match only the files containing the given pattern when grepping" {
  echo "my-pattern" > $NOTES_DIRECTORY/matching-note.md
  echo "some-other-pattern" > $NOTES_DIRECTORY/non-matching-note.md

  run $notes -s grep my-pattern

  assert_success
  assert_line "matching-note.md"
  refute_line "non-matching-note.md"
}

@test "Should grep notes when using the grep shorthand alias" {
  echo "my-pattern" > $NOTES_DIRECTORY/matching-note.md

  run $notes -s g my-pattern

  assert_success
  assert_line "matching-note.md"
}

@test "Should grep case-insensitively" {
  echo "LETTERS" > $NOTES_DIRECTORY/matching-note.md

  run $notes -s grep letter

  assert_success
  assert_line "matching-note.md"
}
