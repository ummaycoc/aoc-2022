oIFS="$IFS"
set -f
INPUT=$(
  < input sed -e 's/, /,/g' -e '/^$/d' |
    paste -d ' ' - - - - - -  |
    awk '{ print $9, $10, $11, $15, $21, $27, $5 }' |
    tr , ' '
)
MONKEYS=( $( <<< "$INPUT" tr ' ' ';' ) )
COUNTS=( $( printf "0%0.0s\n" $( seq 1 ${#MONKEYS[@]} ) ) )
for ROUND in $( seq 1 20 ) ; do
  for INDEX in $( seq 0 $(( ${#MONKEYS[@]} - 1 )) ) ; do
    IFS=';' MONKEY=( ${MONKEYS[$INDEX]} ) IFS="$oIFS"
    LHS=${MONKEY[0]}
    OP=${MONKEY[1]}
    RHS=${MONKEY[2]}
    DIV=${MONKEY[3]}
    TRUE=${MONKEY[4]}
    FALSE=${MONKEY[5]}
    ITEMS=( ${MONKEY[@]:6} )
    COUNTS[$INDEX]=$(( ${COUNTS[$INDEX]} + ${#ITEMS[@]} ))
    for ITEM in ${ITEMS[@]} ; do
      _LHS="${LHS}"
      _RHS="${RHS}"
      [ "${_LHS}" = old ] && _LHS="${ITEM}"
      [ "${_RHS}" = old ] && _RHS="${ITEM}"
      ITEM=$(( ( ${_LHS} ${OP} ${_RHS} ) / 3 ))
      TARGET="$FALSE"
      [ $(( ITEM % DIV )) -eq 0 ] && TARGET="$TRUE"
      MONKEYS[$TARGET]="${MONKEYS[$TARGET]};${ITEM}"
    done
    MONKEYS[$INDEX]="$LHS;$OP;$RHS;$DIV;$TRUE;$FALSE"
  done
done
printf "%s\n" ${COUNTS[@]} | sort -n | tail -n 2 | paste -s -d'*' - | bc
