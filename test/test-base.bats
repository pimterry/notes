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

export EDITOR=touch
notes="./notes"

@test "NOTES_DIRECTORY should be created if it doesn't exist" {
  rm -r $NOTES_DIRECTORY
  run $notes new test
  assert_success
  assert_exists "$NOTES_DIRECTORY/test.md"
}

@test "Should output with directories suppressed by default" {
  touch $NOTES_DIRECTORY/note.md

  run faketty $notes find 
  assert_success
  assert_line "note.md"
}

@test "Should output directories if piped" {
  touch $NOTES_DIRECTORY/note.md

  # This is piped by default because of the run
  run $notes find
  assert_success
  assert_line "$NOTES_DIRECTORY/note.md"
}

@test "Should suppress directories if given --suppress-path" { 
  touch $NOTES_DIRECTORY/note.md

  run $notes --suppress-path find
  assert_success
  assert_line "$NOTES_DIRECTORY/note.md"
}

@test "Should ouptput directories if given --full-path" {
    touch $NOTES_DIRECTORY/note.md

    run faketty $notes --full-path find
    assert_success
    assert_line "$NOTES_DIRECTORY/note.md"
}
