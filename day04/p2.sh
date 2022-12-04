while read ; do
  nums=( $( <<< "$REPLY" tr ',-' ' ' ) )
  (
    ([ ${nums[0]} -le ${nums[2]} ] && [ ${nums[1]} -ge ${nums[3]} ]) ||
    ([ ${nums[0]} -ge ${nums[2]} ] && [ ${nums[1]} -le ${nums[3]} ]) ||
    ([ ${nums[0]} -le ${nums[2]} ] && [ ${nums[2]} -le ${nums[1]} ]) ||
    ([ ${nums[0]} -le ${nums[3]} ] && [ ${nums[3]} -le ${nums[1]} ])
  ) && echo 1
done < input | paste -s -d+ - | bc
