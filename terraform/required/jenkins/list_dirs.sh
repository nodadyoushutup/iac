#!/bin/bash

find ../ -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | jq -R -s -c 'split("\n")[:-1] | {directories: .}'
