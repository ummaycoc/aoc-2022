NSTACKS=( $( < input egrep -m 1 '\d' ) )
NSTACKS="${#NSTACKS[@]}"
STACKS=$( < input grep '\[' | sed -e 's/    / [-]/g' | tr -d '[] ' )
STACKS=( $(
  for i in $( seq 1 $NSTACKS ) ; do
    <<< "$STACKS" cut -c $i | tr -d $'\n'-
    echo
  done
) )
while read ; do
  MOVE=( $REPLY )
  AMT=${MOVE[0]}
  SRC=$(( MOVE[1] - 1 ))
  DST=$(( MOVE[2] - 1 ))
  CRATES=${STACKS[$SRC]:0:$AMT}
  STACKS[$SRC]=${STACKS[$SRC]:$AMT}
  STACKS[$DST]="$( <<< $CRATES rev )${STACKS[$DST]}"
done < <( < input grep move | egrep -o '\d+' | paste -d' ' - - - )
printf "%s\n" ${STACKS[@]} | cut -c 1 | tr -d $'\n'
echo
