#!/bin/bash

source bin/bashful
shopt -s extglob
#DEBUG=true

debug_log(){
  if [[ "$DEBUG" ]];then
    echo "  "$@ >&2
  fi
}

function cat_between(){ 
 debug_log "calling func cat_between"
 local file="$1"
 local start_line="$2"
 local end_line="$3"

 sed -n "${start_line},${end_line}p" "$file"
}

function func_start(){  
  debug_log "calling func func_start"
  local file="$1"
  local func="$2"
  ag "^$func\(\)" "$file" | head -n 1 | cut -d ":" -f 1
}

function cat_from_line(){
  debug_log "calling func cat_from_line"
  local file="$1"
  local start_line="$2"
  local end_line=$(wc -l "$file" | trim | cut -d ' ' -f 1)

  cat_between "$file" "$start_line" "$end_line"
}

function cat_to_line(){
  debug_log "calling func cat_to_line"
  local file="$1"
  local end_line="$2"

  cat_between "$file" "1" "$end_line"
}

function macro_maker(){
  debug_log "calling func macro_maker"
  local file="$1"
  local func_name="$2"
  local source_file="$3"
  local output_dir_base="$4"

  local source_file_dir_name=$(filename "$source_file");
  local output_dir="${output_dir_base}/${source_file_dir_name}"

  local func_name_upper=$(echo $func_name |upper)

  local gpp_file="${output_dir}/${func_name}.sh"

  [[ -d "$output_dir" ]] || mkdir "$output_dir"
  touch "$gpp_file"
  echo "#ifndef $func_name_upper"       >> "$gpp_file"
  echo "#define $func_name_upper"        >> "$gpp_file"
  cat "$file"                            >> "$gpp_file"
  echo "#endif"                          >> "$gpp_file"
}

function get_func_file(){
  debug_log "calling func get_func_file"
  local file="$1"
  local func="$2"
  local output_dir_base="$3"
  # get the function 

  # get the start line 
  local start_line=$(func_start "$file" "$func")
  debug_log "$(tput setaf 1 ) startline $start_line $(tput sgr0)"

  # write from the startline to the end of the file in a tmp file
  local func_tmp_file="${func}.tmp"
  cat_from_line "$file" "$start_line" >> "$func_tmp_file"

  # get the end line
  local end_line=$(ag '^}' "$func_tmp_file" |head -n 1 | cut -d ':' -f 1)

  # create the func file
  local func_file="${func}.func"
  cat_to_line "$func_tmp_file" "$end_line" > "$func_file"

  # remove the tmp files
  rm "$func_tmp_file"

  macro_maker "$func_file" "$func" "$file" "$output_dir_base"
  rm "$func_file"
}

function clean_func_files(){
  debug_log "calling func clean_func_files"
  rm *.func
}

function extract_functions_for_gpp(){
  loop_target="$1"
  output_dir_base=$(relpath "$2")
  for file in $(echo $loop_target);do
    echo "$file"
    for func in $(functions "$file");do
      echo "function: ${func}"
      get_func_file "$file" "$func" "$output_dir_base"
    done
  done
}

[[ -d "$2" ]] || mkdir "$2"

extract_functions_for_gpp "$1" "$2"
