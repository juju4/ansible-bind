#!/usr/bin/env bats

#setup() {
#    apt-get install -y curl >/dev/null || yum -y install curl >/dev/null
#}

@test "process named should be running" {
    run pgrep named
    [ "$status" -eq 0 ]
    [[ "$output" != "" ]]
}
