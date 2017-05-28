#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

# export FOO_STUB_DEBUG=/dev/tty

@test "bats works AOK" {
  echo "AOK"
  assert_success
}

@test "bats-mock works" {
  stub foo "bar : echo baz"
  foo bar
  assert_success
  unstub foo
}