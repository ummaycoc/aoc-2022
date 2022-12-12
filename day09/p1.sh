{
  HX=0
  HY=0
  TX=0
  TY=0
  echo 0,0
  while read ; do
    MOVE=( $REPLY )
    for i in $( seq 1 ${MOVE[1]} ) ; do
      echo ${MOVE[0]}
    done
  done < input | while read ; do
    case $REPLY in
    R)
      HX=$(( HX + 1 ))
      ;;
    L)
      HX=$(( HX - 1 ))
      ;;
    U)
      HY=$(( HY + 1 ))
      ;;
    D)
      HY=$(( HY - 1 ))
      ;;
    esac
    DX=$(( HX - TX ))
    DY=$(( HY - TY ))
    [ ${DX#-} -le 1 -a ${DY#-} -le 1 ] && continue
    [ $DX -ne 0 ] && TX=$(( TX + ( DX / ${DX#-} ) ))
    [ $DY -ne 0 ] && TY=$(( TY + ( DY / ${DY#-} ) ))
    echo "$TX,$TY"
  done
} | sort -u | wc -l
