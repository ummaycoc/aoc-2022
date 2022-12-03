priorities=$(
  while read ; do
    length=${#REPLY}
    half=$(( length / 2 ))
    L=${REPLY:0:half}
    R=${REPLY:half:length}
    comm -1 -2 <( <<< $L grep -o . | sort ) <( <<< $R grep -o . | sort ) | sort | uniq
  done < input # | tr -d $'\n'
)
function calc {
  egrep -o "$1" | tr -d $'\n' | od -An -t uC | xargs | tr ' ' $'\n' | sed -e "s/$/-$2/" | bc
}
{
   <<< "$priorities" calc '[a-z]' 96
   <<< "$priorities" calc '[A-Z]' 38
} | sort -n | uniq -c | sed -e 's/^[[:space:]]*//' -e 's/ /*/' | bc | paste -s -d+ - | bc
