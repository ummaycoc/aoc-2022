choices=$( < input cut -d' ' -f2 | sort | uniq -c | rev | cut -d' ' -f2 | rev | nl -w 1 | sed -e 's/\t/*/' | paste -d+ - - - | bc )
draws=$( < input egrep '(A X|B Y|C Z)' | wc -l )
wins=$( < input egrep '(A Y|B Z|C X)' | wc -l )
echo $(( choices + 3 * draws + 6 * wins ))
