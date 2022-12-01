# In reality executed on a single line.
< input awk '
  BEGIN { total = 0 }
  END { print total }
  /^[[:space:]]*$/ { print total ; total = 0 }
  /^[[:digit:]]*$/ { total += $1 }
' | sort -n | tail -n 3 | paste -d+ - - - | bc
