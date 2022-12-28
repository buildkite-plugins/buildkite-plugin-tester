#!/usr/bin/env bats

load "$BATS_PLUGIN_PATH/load.bash"

# export FOO_STUB_DEBUG=/dev/tty

@test "bats works AOK" {
  run echo 'AOK'
  assert_success
}

@test "bats intentional failure - expects Not AOK" {
  run bash -c "echo 'Not AOK!'; exit 1"
  assert_failure
}

@test "bats-mock works" {
  stub foo "bar : echo baz"
  run foo bar
  assert_success
  unstub foo
}