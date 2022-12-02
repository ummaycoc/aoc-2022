results=$( < input cut -d' ' -f2 | sort | uniq -c | rev | cut -d' ' -f2 | rev | nl -w1 -v0 | sed -e 's/\t/*3*/' | paste -d+ - - - | bc )
rocks=$( < input egrep '(A Y|B X|C Z)' | wc -l )
papers=$( < input egrep '(B Y|C X|A Z)' | wc -l )
scissors=$( < input egrep '(C Y|A X|B Z)' | wc -l )
echo $(( results + 1 * rocks + 2 * papers + 3 * scissors ))
