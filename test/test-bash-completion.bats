#!./test/libs/bats/bin/bats

load 'helpers'

setup() {
  setupNotesEnv
  source notes.bash_completion
  COMP_WORDS=()
}

teardown() {
  teardownNotesEnv
}

@test "Should list all commands" {
  touch $NOTES_DIRECTORY/note1.md
  _notes_complete_commands ""
  assert_contains "new"  "${COMPREPLY[@]}"
  assert_contains "find" "${COMPREPLY[@]}"
  assert_contains "grep" "${COMPREPLY[@]}"
  assert_contains "open" "${COMPREPLY[@]}"
  assert_contains "ls"   "${COMPREPLY[@]}"
  assert_contains "rm"   "${COMPREPLY[@]}"
  assert_contains "search" "${COMPREPLY[@]}"
}

@test "Should show matching note when found" {
  touch $NOTES_DIRECTORY/note1.md
  _notes_complete_notes "no"
  assert_equal "${COMPREPLY[@]}" "note1"
}

@test "Should show multiple matching notes" {
  touch $NOTES_DIRECTORY/note1.md
  touch $NOTES_DIRECTORY/note2.md
  _notes_complete_notes "no"
  assert_equal "${COMPREPLY[0]}" 'note1'
  assert_equal "${COMPREPLY[1]}" 'note2'
  assert_equal 2 "${#COMPREPLY[@]}"
}

@test "Should show one completion for note with space" {
  touch "$NOTES_DIRECTORY/my note.md"
  _notes_complete_notes ""
  assert_equal "${COMPREPLY[0]}" 'my note'
  assert_equal 1 "${#COMPREPLY[@]}"
}

@test "Should ignore hidden files" {
  touch "$NOTES_DIRECTORY/note1.md"
  touch "$NOTES_DIRECTORY/.hiddennote.md"
  _notes_complete_notes ""
  assert_equal "${COMPREPLY[0]}" 'note1'
  assert_equal 1 "${#COMPREPLY[@]}"
}
