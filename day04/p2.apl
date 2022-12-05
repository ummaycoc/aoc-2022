fname ← '/path/to/file'
read ← 'UTF-8' ⎕NGET fname
input ← ¯1↓⊃read[1]
p ← {(4÷⍨≢⍵) 4⍴⍵}⍎¨{⍵⊆⍨~⍵∊'-,',⎕UCS 10}input
over ← {(⍵[;1]≤⍵[;3])∧(⍵[;2]≥⍵[;4])}
btwn ← {(⍵[;1]≤⍵[;3])∧(⍵[;3]≤⍵[;2])}
+/{⊃∨/(btwn ⍵)(btwn ⍵[;1 2 4])(over ⍵)(over ⍵[;3 4 1 2])}p
