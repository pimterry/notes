#!./libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

# Set up a directory for our notes
TMP_DIRECTORY=$(mktemp -d)
NOTES_DIRECTORY="$TMP_DIRECTORY"

notes="./notes"

@test "Should show 'No notes found' and return non-zero if there are no notes" {
  run $notes ls

  assert_failure
  assert_line --partial "No notes found"
}

@test "Should show all notes by default" {
}

@test "Should filter notes to only the matching ones" {
}