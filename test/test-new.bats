#!./test/libs/bats/bin/bats

load 'helpers'

setup() {
  setupNotesEnv
}

teardown() {
  teardownNotesEnv
}

export EDITOR=touch
notes="./notes"

@test "Should create a new note with the given name" {
  run $notes new note

  assert_success
  assert_exists "$NOTES_DIRECTORY/note.md"
}

@test "Should create quicknote without a name given" {
  today=`date "+%Y-%m-%d"`
  run $notes new

  assert_success
  assert_exists "$NOTES_DIRECTORY/quicknote-$today.md"
}

@test "Should append to name if quicknote already exists" {
  today=`date "+%Y-%m-%d"`
  run $notes new
  run $notes new

  assert_success
  assert_exists "$NOTES_DIRECTORY/quicknote-$today.1.md"
}

@test "Should create new notes when using the shorthand alias" {
  run $notes n note

  assert_success
  assert_exists "$NOTES_DIRECTORY/note.md"
}

@test "Should create new notes within subfolders" {
  run $notes new subfolder/note

  assert_success
  assert_exists "$NOTES_DIRECTORY/subfolder/note.md"
}

@test "Should create notes with spaces in the name" {
  run $notes new "note with spaces"

  assert_success
  assert_exists "$NOTES_DIRECTORY/note with spaces.md"
}

@test "Should create notes within subfolders with spaces" {
  run $notes new "subfolder with spaces/note"

  assert_success
  assert_exists "$NOTES_DIRECTORY/subfolder with spaces/note.md"
}

@test "Should create notes within note directories with spaces" {
  NOTES_DIRECTORY="$NOTES_DIRECTORY/notes with spaces" run $notes new "note"

  assert_success
  assert_exists "$NOTES_DIRECTORY/notes with spaces/note.md"
}

@test "Should create quicknote in a subfolder" {
  today=`date "+%Y-%m-%d"`
  run $notes new subfolder/

  assert_success
  assert_exists "$NOTES_DIRECTORY/subfolder/quicknote-$today.md"
}

@test "Should use explicitly named file extensions" {
  run $notes new explicit-ext.zzz

  assert_success
  assert_exists "$NOTES_DIRECTORY/explicit-ext.zzz"
}

@test "Should create a new template note" {
  run $notes new .templates/basic

  assert_success
  assert_exists "$NOTES_DIRECTORY/.templates/basic.md"
}

@test "Should create a new note with the given template" {
  run $notes new .templates/basic
  run $notes new -t basic note_with_template

  assert_success
  assert_exists "$NOTES_DIRECTORY/note_with_template.md"
}

@test "Should create new note from template within subfolders" {
  run $notes new .templates/basic
  run $notes new -t basic subfolder/note_with_template

  assert_success
  assert_exists "$NOTES_DIRECTORY/subfolder/note_with_template.md"
}

@test "Check that the template is used" {
  run $notes append .templates/basic "This is a basic template"
  run $notes new -t basic note_with_template
  run $notes cat note_with_template

  assert_success
  assert_output "This is a basic template"
}
