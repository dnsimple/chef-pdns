#!/usr/bin/env bats

@test "pdns process in list" {
  run pgrep pdns
}
