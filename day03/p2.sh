priorities=$(
  while read ; do
    elves=( $REPLY )
    comm -1 -2 <( <<< ${elves[0]} grep -o . | sort ) <(
      comm -1 -2 <( <<< ${elves[1]} grep -o . | sort ) <( <<< ${elves[2]} grep -o . | sort )
    ) | uniq
  done < <( < input paste -d' ' - - - )
)
function calc {
  egrep -o "$1" | tr -d $'\n' | od -An -t uC | xargs | tr ' ' $'\n' | sed -e "s/$/-$2/" | bc
}
{
   <<< "$priorities" calc '[a-z]' 96
   <<< "$priorities" calc '[A-Z]' 38
} | sort -n | uniq -c | sed -e 's/^[[:space:]]*//' -e 's/ /*/' | bc | paste -s -d+ - | bc
