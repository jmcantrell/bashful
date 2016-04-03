#!/bin/bash

file_glob="$1"

mkdir tmp
for file in $file_glob;do
  cp "$file" tmp/
done
