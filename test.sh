#!/bin/bash

# Unit tests for up.
# A bash script must be tested in bash. I don't make the rules.

# Not using x by default because the output is annoying.
set -e

# All time classic
# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
upfile="$(dirname -- "$0")/up.sh"
. "${upfile}"

# Test directory. mktmp wasn't working on my macbook
tmpdir="/tmp/askjhckjhw90d212d12"
mkdir -p "$tmpdir/a/b/c"

# Script cleanup
cleanup() {
    rv=$?
    rm -rf "$tmpdir"

    if [ $rv != "0" ]; then
        echo "!!! TEST FAILED !!!"
    fi
    exit $rv
}
trap "cleanup" EXIT


# Run a test.
function TEST() {
    func=$1
    echo "TESTING: $func"
    $func
    echo "TEST PASSED: $func"
}


# Test up with no args.
function test_noarg() {
    cd "$tmpdir/a/b/c"
    [[ "$(pwd)" = "$tmpdir/a/b/c" ]]

    up
    [[ "$(pwd)" = "$tmpdir/a/b" ]]
    up
    [[ "$(pwd)" = "$tmpdir/a" ]]
    up
    [[ "$(pwd)" = "$tmpdir" ]]
}


# Test up with a count.
function test_count() {
    cd "$tmpdir/a/b/c"
    [[ "$(pwd)" = "$tmpdir/a/b/c" ]]

    # 1, 2, 3 all basically the same
    up 1
    [[ "$(pwd)" = "$tmpdir/a/b" ]]
    up 2
    [[ "$(pwd)" = "$tmpdir" ]]
    cd "$tmpdir/a/b/c"
    [[ "$(pwd)" = "$tmpdir/a/b/c" ]]
    up 3
    [[ "$(pwd)" = "$tmpdir" ]]

    # Caps out at some point and just takes you to root.
    cd "$tmpdir/a/b/c"
    up 40
    [[ "$(pwd)" = "/" ]]

    # Cap on iterations for crazy insane numbers.
    cd "$tmpdir/a/b/c"
    up 4000
    [[ "$(pwd)" = "/" ]]
}


# Test up with a directory n ame.
function test_dirname() {
    # Direct parent
    cd "$tmpdir/a/b/c"
    [[ "$(pwd)" = "$tmpdir/a/b/c" ]]
    up b
    [[ "$(pwd)" = "$tmpdir/a/b" ]]

    # Ancestor
    cd "$tmpdir/a/b/c"
    [[ "$(pwd)" = "$tmpdir/a/b/c" ]]
    up a
    [[ "$(pwd)" = "$tmpdir/a" ]]

    # Current directory
    cd "$tmpdir/a/b/c"
    [[ "$(pwd)" = "$tmpdir/a/b/c" ]]
    up c
    [[ "$(pwd)" = "$tmpdir/a/b/c" ]]

    # Root directory
    cd "$tmpdir/a/b/c"
    [[ "$(pwd)" = "$tmpdir/a/b/c" ]]
    up /
    [[ "$(pwd)" = "/" ]]

    # Invalid directory
    cd "$tmpdir/a/b/c"
    [[ "$(pwd)" = "$tmpdir/a/b/c" ]]
    up directory_doesnt_exist || true
    [[ "$(pwd)" = "$tmpdir/a/b/c" ]]
}

TEST test_noarg
TEST test_count
TEST test_dirname