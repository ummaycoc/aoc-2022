function move {
  local HX=0
  local HY=0
  local TX=0
  local TY=0
  local DELTA
  local DX
  local DY
  while read ; do
    DELTA=( $REPLY )
    DX=${DELTA[0]}
    DY=${DELTA[1]}
    HX=$(( HX + DX ))
    HY=$(( HY + DY ))
    DX=$(( HX - TX ))
    DY=$(( HY - TY ))
    [ ${DX#-} -le 1 -a ${DY#-} -le 1 ] && continue
    [ $DX -ne 0 ] && DX=$(( DX / ${DX#-} ))
    [ $DY -ne 0 ] && DY=$(( DY / ${DY#-} ))
    TX=$(( TX + DX ))
    TY=$(( TY + DY ))
    echo "$DX $DY"
  done
}

function location {
  local X=0
  local Y=0
  local DELTA
  local DX
  local DY
  echo 0,0
  while read ; do
    DELTA=( $REPLY )
    DX="${DELTA[0]}"
    DY="${DELTA[1]}"
    X=$(( X + DX ))
    Y=$(( Y + DY ))
    echo "$X,$Y"
  done
}

while read ; do
  MOVE=( $REPLY )
  printf "${MOVE[0]}%.0s\n" $( seq 1 "${MOVE[1]}" )
done < input |
  while read ; do
    [ "$REPLY" = R ] && echo  1  0
    [ "$REPLY" = L ] && echo -1  0
    [ "$REPLY" = U ] && echo  0  1
    [ "$REPLY" = D ] && echo  0 -1
  done |
  move head follwed by 1 |
  move 1 followed by 2 |
  move 2 followed by 3 |
  move 3 followed by 4 |
  move 4 followed by 5 |
  move 5 followed by 6 |
  move 6 followed by 7 |
  move 7 followed by 8 |
  move 8 followed by 9 |
  location of knot 9 |
  sort -u |
  wc -l
