{
  HX=0
  HY=0
  TX=0
  TY=0
  echo 0,0
  while read ; do
    MOVE=( $REPLY )
    printf "${MOVE[0]}%.0s\n" $( seq 1 "${MOVE[1]}" )
  done < input |
  while read ; do
    [ "$REPLY" = R ] && HX=$(( ++HX ))
    [ "$REPLY" = L ] && HX=$(( --HX ))
    [ "$REPLY" = U ] && HY=$(( ++HY ))
    [ "$REPLY" = D ] && HY=$(( --HY ))
    DX=$(( HX - TX ))
    DY=$(( HY - TY ))
    [ ${DX#-} -le 1 -a ${DY#-} -le 1 ] && continue
    [ $DX -ne 0 ] && TX=$(( TX + ( DX / ${DX#-} ) ))
    [ $DY -ne 0 ] && TY=$(( TY + ( DY / ${DY#-} ) ))
    echo "$TX,$TY"
  done
} | sort -u | wc -l
