index=0
current=()
while read ; do
  current+=( $REPLY )
  index=$(( index + 1 ))
  [ "${#current[@]}" -gt 14 ] && current=( "${current[@]:1}" )
  [ $( printf '%s\n' "${current[@]}" | sort -u | wc -l ) -eq 14 ] && break
done < <( < input grep -o . )
echo $index
