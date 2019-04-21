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

@test "NOTES_DIRECTORY should be created if it doesn't exist" {
  rm -r $NOTES_DIRECTORY
  run $notes new test
  assert_success
  assert_exists "$NOTES_DIRECTORY/test.md"
}
