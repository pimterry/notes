#!./test/libs/bats/bin/bats

load 'helpers'

setup() {
  setupNotesEnv
}

teardown() {
  teardownNotesEnv
}

notes="./notes"

@test "Should print version successfully if requested" {
  run $notes --version

  assert_success
  assert_line --regexp '^.+ [0-9]\.[0-9]\.[0-9]$'
}