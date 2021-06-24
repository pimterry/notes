#!/usr/bin/env bash

# Run this file to run all the tests in test/*.bats

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
./test/libs/bats/bin/bats test/*.bats
