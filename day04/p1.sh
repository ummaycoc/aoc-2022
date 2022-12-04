while read ; do
  nums=( $( <<< "$REPLY" tr ',-' ' ' ) )
  if (
    ([ ${nums[0]} -le ${nums[2]} ] && [ ${nums[1]} -ge ${nums[3]} ]) ||
    ([ ${nums[0]} -ge ${nums[2]} ] && [ ${nums[1]} -le ${nums[3]} ])
  ) ; then
    echo 1
  fi
done < input | paste -s -d+ - | bc
