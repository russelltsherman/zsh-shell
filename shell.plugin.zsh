#!/usr/bin/env bash

DIR="$( cd "$( dirname $0:A )" && pwd )"
export PATH=$DIR/bin:$PATH

# create a file and make it executable
mkexec() {
  file="${1}"
  touch "$file" && chmod +x "$file"
}
