#!./libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

# Set up a directory for our notes
TMP_DIRECTORY=$(mktemp -d)
export NOTES_DIRECTORY="$TMP_DIRECTORY"

notes="./notes"

@test "Should print help successfully if requested" {
  run $notes --help

  assert_success
  assert_line "Usage:" 
}

@test "Should print help if no arguments are provided, and exit unsuccessfully" {
  run $notes

  assert_failure
  assert_line "Usage:"
}

@test "Should print help if an unrecognized command is used, and exit unsuccessfully" {
  run $notes imaginary-command

  assert_failure
  assert_line "Usage:"
}