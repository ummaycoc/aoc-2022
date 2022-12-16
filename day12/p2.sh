E=$( < input grep -n E )
E=( $( <<< "$E" cut -d: -f1 ) $( <<< "$E" cut -d: -f2 | grep -o . | grep -n E | cut -d: -f1 ) )
E=( $(( ${E[1]} - 1 )) $(( ${E[0]} - 1 )) )

BOARD=( $( < input tr SE az ) )
TARGET=( $( < input tr SE az | tr '[b-z]' '[a-y]' ) )
LENGTH="${#BOARD[0]}"
HEIGHT="${#BOARD[@]}"

SIZE=$(( LENGTH * HEIGHT ))
DIST=()
VISITED=()
for ROWINDEX in $( seq 1 $HEIGHT ) ; do
  DIST+=( "$( printf " ${SIZE}%0.0s" $( seq 1 $LENGTH ) )" )
  VISITED+=( "$( printf " -%0.0s" $( seq 1 $LENGTH ) )" )
done

function neighbors {
  [ $1 -gt 0 ] && echo "$(( ${1} - 1 )) $2"
  [ $2 -gt 0 ] && echo "$1 $(( ${2} - 1 ))"
  [ $(( ${1} + 1 )) -lt $LENGTH ] && echo "$(( ${1} + 1 )) $2"
  [ $(( ${2} + 1 )) -lt $HEIGHT ] && echo "$1 $(( ${2} + 1 ))"
}

CYA=( $( seq 0 $(( HEIGHT - 1 )) ) )
CXA=( $( seq 0 $(( LENGTH - 1 )) ) )

function findMin {
  local MX=0
  local MY=0
  local MV=$SIZE
  local CLINE
  local VLINE
  local CX
  local CY
  local CV
  for CY in "${CYA[@]}" ; do
    CLINE=( ${DIST[$CY]} )
    VLINE=( ${VISITED[$CY]} )
    for CX in "${CXA[@]}" ; do
      if [ "${VLINE[$CX]}" = - -a "${CLINE[$CX]}" -lt "$MV" ] ; then
        MX=$CX
        MY=$CY
        MV=${CLINE[$CX]}
      fi
    done
  done
  echo "$MX $MY"
}

X=${E[0]}
Y=${E[1]}
LINE="${DIST[$Y]}"
LINE=( $LINE )
LINE[$X]=0
DIST[$Y]="${LINE[@]}"

for ITER in $( seq 1 $SIZE ) ; do
  CURRENT=${BOARD[$Y]:$X:1}
  MIN=${TARGET[$Y]:$X:1}
  CDIST=( ${DIST[$Y]} )
  CDIST=${CDIST[$X]}
  while read ; do
    NBR=( $REPLY )
    NX=${NBR[0]}
    NY=${NBR[1]}
    [ "${BOARD[$NY]:${NX}:1}" \< $MIN ] && continue
    LINE=( ${DIST[$NY]} )
    NDIST=${LINE[$NX]}
    [ $CDIST -lt $NDIST ] && LINE[$NX]=$(( CDIST + 1 ))
    DIST[$NY]="${LINE[@]}"
  done < <( neighbors $X $Y )
  LINE=( ${VISITED[$Y]} )
  LINE[$X]='+'
  VISITED[$Y]="${LINE[@]}"
  POS=( $( findMin ) )
  X=${POS[0]}
  Y=${POS[1]}
done

for Y in "${CYA[@]}" ; do
  LINE=( ${DIST[$Y]} )
  for X in "${CXA[@]}" ; do
    [ "${BOARD[$Y]:$X:1}" = a ] && echo ${LINE[$X]}
  done
done | sort -n | head -n 1
