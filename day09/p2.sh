
function parseArrow {
  local DX
  local DY
  if [[ "$1" =~ [↗→↘] ]] ; then
    DX=1
  elif [[ "$1" =~ [↖←↙] ]] ; then
    DX=-1
  else
    DX=0
  fi
  if [[ "$1" =~ [↖↑↗] ]] ; then
    DY=1
  elif [[ "$1" =~ [↙↓↘] ]] ; then
    DY=-1
  else
    DY=0
  fi
  echo "$DX $DY"
}

function move {
  local HX=0
  local HY=0
  local TX=0
  local TY=0
  local DELTA
  local DX
  local DY
  while read ; do
    DELTA=( $( parseArrow "$REPLY" ) )
    DX=${DELTA[0]}
    DY=${DELTA[1]}
    HX=$(( HX + DX ))
    HY=$(( HY + DY ))
    DX=$(( HX - TX ))
    DY=$(( HY - TY ))
    [ ${DX#-} -le 1 -a ${DY#-} -le 1 ] && continue
    MOVE=$(
      if [ $DY -gt 0 ] ; then
        [ $DX -lt 0 ] && echo ↖
        [ $DX -eq 0 ] && echo ↑
        [ $DX -gt 0 ] && echo ↗
      elif [ $DY -eq 0 ] ; then
        [ $DX -lt 0 ] && echo ←
        [ $DX -gt 0 ] && echo →
      else
        [ $DX -lt 0 ] && echo ↙
        [ $DX -eq 0 ] && echo ↓
        [ $DX -gt 0 ] && echo ↘
      fi
    )
    DELTA=( $( parseArrow "$MOVE" ) )
    DX=${DELTA[0]}
    DY=${DELTA[1]}
    TX=$(( TX + DX ))
    TY=$(( TY + DY ))
    echo "$MOVE"
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
    DELTA=( $( parseArrow "$REPLY" ) )
    DX="${DELTA[0]}"
    DY="${DELTA[1]}"
    X=$(( X + DX ))
    Y=$(( Y + DY ))
    echo "$X,$Y"
  done
}

< input tr RLUD →←↑↓ |
  while read ; do
    MOVE=( $REPLY )
    for i in $( seq 1 ${MOVE[1]} ) ; do
      echo "${MOVE[0]}"
    done
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
