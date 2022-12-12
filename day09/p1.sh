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
    if [ ${DX#-} -eq 2 ] ; then
      TX=$(( TX + ( DX / 2 ) ))
      TY=$(( TY + DY ))
    elif [ ${DY#-} -eq 2 ] ; then
      TY=$(( TY + ( DY / 2 ) ))
      TX=$(( TX + DX ))
    else
      >&2 echo "Invalid deltas: $DX / $DY"
      exit 1
    fi
    echo "$TX,$TY"
  done
} | sort -u | wc -l
