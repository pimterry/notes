assert_exists() {
  assert [ -e "$1" ]
}

refute_exists() {
  assert [ ! -e "$1" ]
}

assert_contains() {
  local item
  for item in "${@:2}"; do
    if [[ "$item" == "$1" ]]; then
      return 0
    fi
  done

  batslib_print_kv_single_or_multi 8 \
        'expected' "$1" \
        'actual'   "$(echo ${@:2})" \
      | batslib_decorate 'item was not found in the array' \
      | fail
}

setupNotesEnv() {
  export NOTES_DIRECTORY="$(mktemp -d)"
  export NOTES_HOME="$(mktemp -d)"
  export HOME=$NOTES_HOME
}

faketty() {
    script -qefc "$(printf "%q " "$@")" | sed 's/\r$//' 
}

teardownNotesEnv() {
  if [ $BATS_TEST_COMPLETED ]; then
    rm -rf $NOTES_DIRECTORY
    rm -rf $NOTES_HOME
  else
    echo "** Did not delete $NOTES_DIRECTORY, as test failed **"
  fi
}
