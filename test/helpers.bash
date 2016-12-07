assert_exists() {
  assert [ -e "$1" ]
}

refute_exists() {
  assert [ ! -e "$1" ]
}

setupNotesEnv() {
  export NOTES_DIRECTORY="$(mktemp -d)"
  export NOTES_HOME="$(mktemp -d)"
  export HOME=$NOTES_HOME
}

teardownNotesEnv() {
  if [ $BATS_TEST_COMPLETED ]; then
    rm -rf $NOTES_DIRECTORY
    rm -rf $NOTES_HOME
  else
    echo "** Did not delete $NOTES_DIRECTORY, as test failed **"
  fi
}
