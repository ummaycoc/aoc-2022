S=$( < input grep -n S )
S=( $( <<< "$S" cut -d: -f1 ) $( <<< "$S" cut -d: -f2 | grep -o . | grep -n S | cut -d: -f1 ) )
E=$( < input grep -n E )
E=( $( <<< "$E" cut -d: -f1 ) $( <<< "$E" cut -d: -f2 | grep -o . | grep -n E | cut -d: -f1 ) )
S=( $(( ${S[1]} - 1 )) $(( ${S[0]} - 1 )) )
E=( $(( ${E[1]} - 1 )) $(( ${E[0]} - 1 )) )

MARK='|'
BOARD=( $( < input tr SE az ) )
TARGET=( $( < input tr SE az | tr '[a-z]' '[b-zz]' ) )
LENGTH="${#BOARD[0]}"
HEIGHT="${#BOARD[@]}"

function moves {
  local X=$1
  local Y=$2
  local ELEVATION="${BOARD[$Y]:$X:1}"
  local ALLOWED="${TARGET[$Y]:$X:1}"
  local POS
  [ "$ELEVATION" = "$MARK" ] && return 0
  {
    [ $X -gt 0 ] && echo "$(( X - 1 )) $Y"
    [ $Y -gt 0 ] && echo "$X $(( Y - 1 ))"
    [ $(( X + 1 )) -lt $LENGTH ] && echo "$(( X + 1 )) $Y"
    [ $(( Y + 1 )) -lt $HEIGHT ] && echo "$X $(( Y + 1 ))"
  } | while read ; do
    POS=( $REPLY )
    [ "${BOARD[${POS[1]}]:${POS[0]}:1}" \> "$ALLOWED" ] || echo "$REPLY"
  done
}

QUEUE=( "${S[0]} ${S[1]} 0" )
INDEX=0
while [ $INDEX -lt "${#QUEUE[@]}" ] ; do
  LOC=( ${QUEUE[$INDEX]} )
  DEPTH="${LOC[2]}"
  INDEX=$(( INDEX + 1 ))
  [ "${LOC[0]}" -eq "${E[0]}" -a "${LOC[1]}" -eq "${E[1]}" ] && break
  while read ; do
    [ -n "$REPLY" ] && QUEUE+=( "$REPLY $(( DEPTH + 1 ))" )
  done < <( moves "${LOC[0]}" "${LOC[1]}" )
  LINE="${BOARD[${LOC[1]}]}"
  if [ "${LOC[0]}" -eq 0 ] ; then
    LINE="$MARK${LINE:1}"
  elif [ "${LOC[0]}" -eq $LENGTH ] ; then
    LINE="${LINES:0:$(( LENGTH - 1 ))}$MARK"
  else
    LINE="${LINE:0:${LOC[0]}}$MARK${LINE:$(( ${LOC[0]} + 1 ))}"
  fi
  BOARD[${LOC[1]}]="$LINE"
done
echo ${LOC[2]}
