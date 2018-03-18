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

@test "Configuration should override file extension" {
  mkdir -p $HOME/.config/notes
  echo "NOTES_EXT=txt" > $HOME/.config/notes/config
  run $notes new test

  assert_success
  assert_exists "$NOTES_DIRECTORY/test.txt"
}

@test "Configuration should be accepted if NOTES_DIR doesn't exist" {
  mkdir -p $HOME/.config/notes
  echo "NOTES_DIRECTORY=$NOTES_DIRECTORY/notesdir" > $HOME/.config/notes/config
  run $notes new test

  assert_success
}

@test "Configuration should be rejected if NOTES_DIR is a existing file" {
  mkdir -p $HOME/.config/notes
  touch $NOTES_DIRECTORY/testfile
  echo "NOTES_DIRECTORY=$NOTES_DIRECTORY/testfile" > $HOME/.config/notes/config
  run $notes new test

  assert_failure
  assert_line "Could not create directory $NOTES_DIRECTORY/testfile, please update your \$NOTES_DIRECTORY"
}