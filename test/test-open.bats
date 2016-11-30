#!./libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

function open() { echo "Opening $*"; }
export -f open

notes="./notes"

@test "Opens the default notes directory if not configured" {
  run $notes open

  assert_success
  assert_output "Opening $HOME/notes" 
}

@test "Opens the configured notes directory if set" {
  TMP_DIRECTORY=$(mktemp -d)
  export NOTES_DIRECTORY="$TMP_DIRECTORY"

  run $notes open

  assert_success
  assert_output "Opening $NOTES_DIRECTORY"
}