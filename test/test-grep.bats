#!./libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

# Set up a directory for our notes
TMP_DIRECTORY=$(mktemp -d)
export NOTES_DIRECTORY="$TMP_DIRECTORY"

notes="./notes"

@test "Should complain and ask for a pattern if not is provided to grep" {
  run $notes grep

  assert_failure
  assert_line "Grep requires a pattern, but none was provided."
}

@test "Should match only the files containing the given pattern when grepping" {
  echo "my-pattern" > $NOTES_DIRECTORY/matching-node.md
  echo "some-other-pattern" > $NOTES_DIRECTORY/non-matching-node.md

  run $notes grep my-pattern

  assert_success
  assert_line "matching-node.md:my-pattern"
  refute_line "non-matching-node.md"
}