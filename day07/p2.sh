function readinput {
  DIR=
  while read ; do
    case "$REPLY" in
    '$ cd /')
      DIR=/
      ;;
    '$ cd ..')
      DIR=$( dirname "$DIR" )
      ;;
    '$ cd '*)
      if [ "$DIR" = / ] ; then
        DIR="/${REPLY:5}"
      else
        DIR="${DIR}/${REPLY:5}"
      fi
      ;;
    '$ ls')
      ;; # ignore
    'dir '*)
      ;; # ignore
    *)
      SIZE=$( <<< "$REPLY" cut -d' ' -f1 )
      echo "$( <<< "${DIR}/" sed -e 's!//!/!' | grep -o / | tr -d $'\n' ) $DIR $SIZE"
      ;;
    esac
  done < input
}

function combine {
  PREV=
  while read ; do
    if [ -z "$PREV" ] ; then
      PREV="$REPLY"
      continue
    fi
    PENTRY=( $PREV )
    CENTRY=( $REPLY )
    if [ "${PENTRY[1]}" = "${CENTRY[1]}" ] ; then
      PREV="${PENTRY[0]} ${PENTRY[1]} $(( PENTRY[2] + CENTRY[2] ))"
    else
      echo "$PREV"
      PREV="$REPLY"
    fi
  done
  echo "$PREV"
}

function process {
  LINES=$( sort | tail -r | combine )
  while [ $( <<< "$LINES" wc -l ) -gt 1 ] ; do
    PREFIX=$( <<< "$LINES" head -n 1 | cut -d' ' -f1 )
    <<< "$LINES" grep "^${PREFIX}" | cut -d' ' -f2-
    PRUNED=$( <<< "$LINES" grep "^${PREFIX}" | prune )
    UNPRUNED=$( <<< "$LINES" grep -v "^${PREFIX}" )
    LINES=$( printf '%s\n' "$PRUNED" "$UNPRUNED" | sort | tail -r | combine )
  done
  <<< "$LINES" cut -d' ' -f2-
}

function prune {
  while read ; do
    ENTRY=( $REPLY )
    DIR=$( dirname "${ENTRY[1]}" )
    SIZE="${ENTRY[2]}"
    echo "$( <<< "${DIR}/" sed -e 's!//!/!' | grep -o / | tr -d $'\n' ) $DIR $SIZE"
  done
}

DIRS=$( readinput | process | cut -d' ' -f2 )
MAX=$( <<< "$DIRS" sort -n | tail -n 1 )
FREE="$(( 70000000 - MAX ))"
NEED="$(( 30000000 - FREE ))"
<<< "$DIRS" awk -v "NEED=$NEED" '$1 >= NEED' | sort -n | head -n 1
