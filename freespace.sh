
#!/bin/bash

#default values that change only if specified 
recursive=0
time=48

# explaining how to use the script 
usage() {
  echo "Usage: freespace [-r] [-t ###] file [file...]"
}

#using flags 
while getopts 'rt:' OPTION; do 
    case ${OPTION} in 
        r) recursive=1 
         echo "Recursive is on"
        ;;
        t) time=$OPTARG   
         echo "File Age is on with $OPTARG hours" 
        ;;
        *) usage
          exit 1 
        ;;
    esac
done 
shift $((OPTIND-1))

#cheacking if our file is comppressed 
is_file_compressed(){
    file=$1
    case ${file##*.} in 
        zip|tgz|tar.gz|bz2|gz) echo " $file  is already zipped" 
        return 0 ;; 
        *) echo " $file is not zipped " 
         return 1 ;;
    esac
}

#checking if our file is old 
is_file_old(){
    local file=$1
    local time=$2
    local now=$(date +%s)
    local file_age=$(stat -c %Y "$file")
    local time_passed=$((now - file_age))
    local time_in_secs=$((time * 3600))
    if [ "$time_passed" -lt "$time_in_secs" ]; then
        echo "this "$file"  is ok" 
        return 0
    fi
    return 1
}

  # If file is already compressed and named fc-*, check if it's old
  if [[ "$file" == "fc-*" ]]; then
    if is_file_old "$file" "$time"; then
      rm "$file"
      echo 'deleting an old file ' #4
      exit 
    fi
  fi


# compress file if it's not compressed
compress() {
  local file=$1
  local new_file=fc-${file}
  if ! is_file_compressed "$file"; then 
    mv "$file" "$new_file"
    touch "$new_file"
    echo "Renaming and touching $file"
  else
    new_file=fc-${file%.*}.zip
    zip "$new_file" "$file"
    rm "$file"
    echo "Compressed $file and removed original file"
    
  fi
}

#process file and folder 
process_file() {
  local file=$1
  if [ -f "$file" ] && [ "$file" != "fc-*" ]; then 
    if is_file_old "$file" "$time"; then
      rm "$file"
      echo "File $file removed cuz of the age"
    else
      compress "$file"
    fi
  elif [ -d "$file" ] && [ "$recursive" -eq 1 ] ; then 
    for f in "$file"/* ; do 
      process_file "$f"
    done 
  fi
}


#main 
for file in "$@" ; do 
  process_file "$file"
done


