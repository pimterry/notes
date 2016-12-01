assert_exists() {
  assert [ -f "$1" ]
}

setupNotesEnv() {
  export NOTES_DIRECTORY="$(mktemp -d)"

  export FAKE_TTY="$(mktemp)"
  function tty() { echo $FAKE_TTY; }
  export -f tty
}

teardownNotesEnv() {
  if [ $BATS_TEST_COMPLETED ]; then
    rm -rf $NOTES_DIRECTORY
    rm -f $FAKE_TTY
  else
    echo "** Did not delete $NOTES_DIRECTORY or tty $FAKE_TTY, as test failed **"
  fi
}