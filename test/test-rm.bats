#!./test/libs/bats/bin/bats

load 'helpers'

setup() {
  setupNotesEnv
}

teardown() {
  teardownNotesEnv
}

notes="./notes"

@test "Should remove created note" {
  touch "$NOTES_DIRECTORY/note.md"
  run $notes rm note

  assert_success
  refute_exists "$NOTES_DIRECTORY/note.md"
}

@test "Should fail to delete non-existent note" {
  run $notes rm note

  assert_failure
}

@test "Should fail when no file or folder given" {
  run $notes rm

  assert_failure
}

@test "Should remove note in folder" {
  mkdir "$NOTES_DIRECTORY/folder"
  touch "$NOTES_DIRECTORY/folder/note.md"
  run $notes rm folder/note

  assert_success
  refute_exists "$NOTES_DIRECTORY/folder/note.md"
}

@test "Should fail to remove folder" {
  mkdir "$NOTES_DIRECTORY/folder"
  run $notes rm folder

  assert_failure
  assert_exists "$NOTES_DIRECTORY/folder"
}

@test "-r Should remove folder recursively" {
  mkdir "$NOTES_DIRECTORY/folder"
  touch "$NOTES_DIRECTORY/folder/note.md"
  run $notes rm -r folder

  assert_success
  refute_exists "$NOTES_DIRECTORY/folder"
  refute_exists "$NOTES_DIRECTORY/folder/note.md"
}

@test "-r Should fail if no file or folder given" {
  mkdir "$NOTES_DIRECTORY/folder"
  touch "$NOTES_DIRECTORY/folder/note.md"
  run $notes rm -r

  assert_failure
  assert_line "Remove requires a file or folder, but none was provided."
  assert_exists "$NOTES_DIRECTORY/folder"
  assert_exists "$NOTES_DIRECTORY/folder/note.md"
}

@test "--recursive Should remove folder recursively" {
  mkdir "$NOTES_DIRECTORY/folder"
  touch "$NOTES_DIRECTORY/folder/note.md"
  run $notes rm --recursive folder

  assert_success
  refute_exists "$NOTES_DIRECTORY/folder"
  refute_exists "$NOTES_DIRECTORY/folder/note.md"
}

@test "--recursive Should fail if no file or folder given" {
  mkdir "$NOTES_DIRECTORY/folder"
  touch "$NOTES_DIRECTORY/folder/note.md"
  run $notes rm --recursive

  assert_failure
  assert_line "Remove requires a file or folder, but none was provided."
  assert_exists "$NOTES_DIRECTORY/folder"
  assert_exists "$NOTES_DIRECTORY/folder/note.md"
}

@test "should delete file if both folder and file exists" {
  mkdir "$NOTES_DIRECTORY/folder"
  touch "$NOTES_DIRECTORY/folder.md"
  run $notes rm --recursive folder

  assert_success
  assert_exists "$NOTES_DIRECTORY/folder"
  refute_exists "$NOTES_DIRECTORY/folder.md"
}
