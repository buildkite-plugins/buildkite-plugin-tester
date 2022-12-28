#!/usr/bin/env bats

load "$BATS_PLUGIN_PATH/load.bash"

# export FOO_STUB_DEBUG=/dev/tty

@test "bats works AOK" {
  run echo 'AOK'
  assert_success
}

@test "bats-mock works" {
  stub foo "bar : echo baz"
  run foo bar
  assert_success
  unstub foo
}