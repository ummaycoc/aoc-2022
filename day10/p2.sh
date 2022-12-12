{
  X=1
  while read ; do
    if [ "$REPLY" = noop ] ; then
      echo "$X"
    else
      AMT=$( <<< "$REPLY" cut -d' ' -f2 )
      echo "$X"
      echo "$X"
      X=$(( X + AMT ))
    fi
  done < input
} | nl -v 0 | while read ; do
  INFO=( $REPLY )
  CYCLE=$(( ${INFO[0]} % 40 ))
  X=${INFO[1]}
  if [ $CYCLE -ge $(( $X - 1 )) -a $CYCLE -le $(( X + 1 )) ] ; then
    echo '#'
  else
    echo .
  fi
done | tr -d $'\n' | fold -w 40
echo
