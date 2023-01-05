#!/usr/bin/env bats

setup() {
  load "$BATS_PLUGIN_PATH/load.bash"

  # Uncomment to enable stub debugging
  # export BAR_STUB_DEBUG=/dev/tty
}

@test "bats intentional failure - expects Not AOK" {
  run bash -c "echo 'Not AOK!'; exit 1"
  assert_failure
}

@test "bats-mock should throw error" {
  stub bar "foo : exit 1"
  run bar foo
  assert_failure
  unstub bar
}

@test "bats intentional failure - alerts error" {
  run echo "error"

  refute_line "success"
  assert_line "error"

  run exit 1
  assert_failure
}