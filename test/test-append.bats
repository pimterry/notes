#!./test/libs/bats/bin/bats

load 'helpers'

setup() {
  setupNotesEnv
}

teardown() {
  teardownNotesEnv
}

notes="./notes"

@test "Appends a note with a message from commandline" {
  $notes append note.md Test
  run $notes cat note.md

  assert_success
  assert_output $'Test'
}

@test "Doesn't override a file, it actually appends" {
  $notes append note.md Test1
  $notes append note.md Test2
  run $notes cat note.md

  assert_success
  assert_output $'Test1\nTest2'
}

@test "Accepts input from stdin pipe" {
  echo "Echo Test" | $notes append note.md
  run $notes cat note.md

  assert_success
  assert_output $'Echo Test'
}

@test "Works with more than one word given via commandline" {
    $notes append note.md Multi word test
    run $notes cat note.md

    assert_success
    assert_output $'Multi word test'
}

@test "Fails when no message is given" {
  run $notes append note.md

  assert_failure
  assert_output $'No text was provided to append'
}

@test "Shortname works to invoke append" {
  $notes a note.md Test
  run $notes cat note.md

  assert_success
  assert_output $'Test'
}

@test "Should complain and ask for a name if one is not provided" {
  run $notes append

  assert_failure
  assert_line "Append requires a name, but none was provided."
}
