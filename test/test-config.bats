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

@test "Configuration should override QUICKNOTE_FORMAT" {
  mkdir -p $HOME/.config/notes
  echo "QUICKNOTE_FORMAT=test" > $HOME/.config/notes/config
  
  run $notes new
  
  assert_success
  assert_exists "$NOTES_DIRECTORY/test.md"
}

@test "Configuration should override EDITOR" {
  mkdir -p $HOME/.config/notes
  echo "EDITOR=echo" > $HOME/.config/notes/config
  run $notes new test
  
  assert_success
  assert_line "$NOTES_DIRECTORY/test.md"
}
