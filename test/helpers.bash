assert_exists() {
  assert [ -e "$1" ]
}

refute_exists() {
  assert [ ! -e "$1" ]
}

setupNotesEnv() {
  export NOTES_DIRECTORY="$(mktemp -d)"
}

teardownNotesEnv() {
  if [ $BATS_TEST_COMPLETED ]; then
    rm -rf $NOTES_DIRECTORY
  else
    echo "** Did not delete $NOTES_DIRECTORY, as test failed **"
  fi
}
