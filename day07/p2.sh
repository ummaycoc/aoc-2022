function readinput {
  DIR=
  while read ; do
    case "$REPLY" in
    '$ cd /')
      DIR=/
      ;;
    '$ cd ..')
      DIR="$( dirname "$DIR" )"
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
      SIZE="$( <<< "$REPLY" cut -d' ' -f1 )"
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
  sort | tail -r | combine | process_rec
}

function process_rec {
  LINES="$( process_top )"
  [ "$( <<< "$LINES" wc -l | xargs )" -gt 1 ] && <<< "$LINES" process
}

function process_top {
  PREFIX=
  while read ; do
    CPREFIX="$( <<< "$REPLY" cut -d' ' -f1 )"
    [ -z "$PREFIX" ] && PREFIX="$CPREFIX"
    if [ "$PREFIX" != "$CPREFIX" ] ; then
      echo "$REPLY"
      break
    fi
    push "$REPLY"
  done
  cat
}

PIPE="./p1.fifo"

function push {
  ENTRY=( $1 )
  DIR=$( dirname "${ENTRY[1]}" )
  SIZE="${ENTRY[2]}"
  echo "$( <<< "${DIR}/" sed -e 's!//!/!' | grep -o / | tr -d $'\n' ) $DIR $SIZE"
  >&3 echo "${ENTRY[1]} $SIZE"
}

function filter {
  LINES="$( cut -d' ' -f2 )"
  MAX="$( <<< "$LINES" sort -n | tail -n 1 )"
  FREE="$(( 70000000 - MAX ))"
  NEED="$(( 30000000 - FREE ))"
  while read ; do
    [ "$REPLY" -gt "$NEED" ] && echo "$REPLY"
  done <<< "$LINES" | sort -n | head -n 1
}

trap "rm -f $PIPE" EXIT
rm -f "$PIPE"
mkfifo "$PIPE"
< "$PIPE" filter &
3> "$PIPE" exec

readinput | process
