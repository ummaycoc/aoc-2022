{
  X=1
  CYCLE=1
  while read ; do
    if [ "$REPLY" = noop ] ; then
      echo "$CYCLE $X"
      CYCLE=$(( CYCLE + 1 ))
    else
      AMT=$( <<< "$REPLY" cut -d' ' -f2 )
      echo "$CYCLE $X"
      CYCLE=$(( CYCLE + 1 ))
      echo "$CYCLE $X"
      CYCLE=$(( CYCLE + 1 ))
      X=$(( X + AMT ))
    fi
  done < input
} | egrep '^(20|60|100|140|180|220) ' | tr ' ' '*' | paste -s -d+ - | bc
