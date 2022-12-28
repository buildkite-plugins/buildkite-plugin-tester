#!/usr/bin/env bats

load "$BATS_PLUGIN_PATH/load.bash"

# export FOO_STUB_DEBUG=/dev/tty

@test "bats works AOK" {
  run bash -c "echo 'AOK'"
  assert_success
}

@test "bats-mock works" {
  stub foo \
    "bar : echo baz"
  run foo bar
  assert_success
  unstub foo
}

# # @test 'assert_success() status only' {
# #   run bash -c "echo 'Error!'; exit 1"
# #   assert_success
# # }

# # @test 'assert_failure() status only' {
# #   run echo 'Success!'
# #   assert_failure
# # }

# @test 'assert success' {
#   run bash -c "echo 'this'"
#   assert_success
# }

@test "echoing" {
  run echo "AOK"
  assert_success
}

@test "stubbing" {
  stub greet "sayhi: echo hello"
  run greet sayhi
  assert_success
  unstub greet
}