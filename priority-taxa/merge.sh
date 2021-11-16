#!/usr/bin/env bash

csv_files=() # collect input filenames in an array
for dir in *; do
    if ! [[ -d "${dir}" ]]; then
        continue
    fi
    files=( $(ls -r "${dir}/"*.csv) )
    #echo "Dir: ${dir}"
    for file_path in "${files[@]}"; do
        #echo -e "\tFile: ${file_path}"
        csv_files+=( "${file_path}" )
        break
    done
done
echo "Used files list: ${csv_files[*]}"

{
  head -n 2 "${csv_files[0]}" # output the header lines (using the 1st file)
  tail -q -n +3 "${csv_files[@]}" # append the data lines from all files, in sequence
}  > taxa.csv