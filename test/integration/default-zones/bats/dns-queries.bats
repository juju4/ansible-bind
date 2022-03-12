#!/usr/bin/env bats

setup() {
    apt-get install -y ldnsutils >/dev/null || yum -y install bind-utils >/dev/null
}

@test "standard dns resolution: host www.google.com" {
    run host www.google.com
    [ "$status" -eq 0 ]
    [[ "$output" != "SERVFAIL" ]]
}

@test "standard dns resolution: host www.yahoo.com" {
    run host www.yahoo.com
    [ "$status" -eq 0 ]
    [[ "$output" != "SERVFAIL" ]]
}

@test "standard dns resolution: host www.bing.com" {
    run host www.bing.com
    [ "$status" -eq 0 ]
    [[ "$output" != "SERVFAIL" ]]
}
