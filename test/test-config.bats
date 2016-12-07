#!./libs/bats/bin/bats

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

@test "Configuration should override EDITOR" {
  mkdir -p $HOME/.config/notes
  echo "EDITOR=echo" > $HOME/.config/notes/config
  run $notes new test
  
  assert_success
  assert_line "$NOTES_DIRECTORY/test.md"
}
