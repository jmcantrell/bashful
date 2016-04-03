#!/bin/bash
shopt -s extglob
source bin/bashful

function cat_betwen(){
  local file start_line end_line
  file="$1"
  start_line="$2"
  end_line="$3"

  sed -n "${start_line},${end_line}p" "$file"
}

function print_line_from_file(){  
  local file line_number
  file="$1"
  line_number="$2"
  cat_betwen "$file" "$line_number" "$line_number"
}

function prepend_to_file(){
  local file tmp_file prepend
  file="$1"
  prepend="$2"
  tmp_file="${file}.txt"
  echo "$prepend" > "$tmp_file"
  cat "$file" >> "$tmp_file"
  mv "$tmp_file" "$file"
}

function append_to_file(){
  local file tmp_file append
  file="$1"
  append="$2"
  echo "$append" >> "$file"
  
}

function add_space_around_paren_in_files(){
  sed -i '' 's/)/ ) /g' $@
  sed -i '' 's/(/ ( /g' $@
}

function remove_space_around_paren_in_files(){
  sed -i '' 's/ ) /)/g' $@
  sed -i '' 's/ ( /(/g' $@
}

function find_files_that_use_func(){
  local file search_glob func files_using_func mention_func
  file="$1"
  search_glob="$2" 
  files_using_func=()
  func=$(functions "$file")
  [[ "$func" ]] || return 
  add_space_around_paren_in_files $search_glob
  mention_func=$(grep -wn "$func" $search_glob)
  if [[ ! -z $mention_func ]];then
    while read -r line;do
      #echo "found line $line"
      mention_file=$(echo "$line" |cut -d':' -f 1)
      mention_line_number=$(echo "$line" |cut -d':' -f 2)
      #echo "    mention_file: $mention_file"
      #echo "    mention_line_number: $mention_line_number"
      mention_line_trim_content=$(print_line_from_file "$mention_file" "$mention_line_number"| trim)
      if [[ ! "${mention_line_trim_content:0:1}" = "#" ]];then
        files_using_func+=("$mention_file")
      fi
    done <<< "$mention_func"
  sorted_unique_files=$(echo "${files_using_func[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
  echo "$sorted_unique_files"
  fi
  remove_space_around_paren_in_files $search_glob
}

#find_files_that_use_func ./tmp/gpp-verbose.sh "./tmp/!(gpp-verbose.sh)"

function add_include_macros(){ 
  local file_glob source_file_basename need_include include_path
  file_glob="$1"
  for source_file in $file_glob;do
    source_file_basename=$(basename "$source_file")
    echo "source_file_basename: $source_file_basename"
    exclude_path=$(dirname "$source_file")
    need_include=$(find_files_that_use_func "$source_file" "$exclude_path/!($source_file_basename)")
    #find_files_that_use_func "$source_file" "./tmp/!($source_file_basename)"
    #echo "need_include"
    for file in $(echo "$need_include");do
      include_path=$(relpath "$source_file")
      echo "    $file needs $include_path"
      prepend_to_file "$file" "#include \"$include_path\""
     done
  done
}

mkdir lib/tmp
cp lib/gpp*/*.sh lib/tmp
file_glob="lib/tmp/*"
add_include_macros "$file_glob"
#rm -rf lib/tmp
