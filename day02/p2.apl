name ← '/path/to/file'
read ← 'UTF-8' ⎕NGET fname
input ← ¯1↓⊃read[1]
results ← {(3×¯1+⍳3)+.×2⌷[2]((⊂⍋)⌷⊣)({⍺,≢⍵}⌸)⍵[⍸⍵∊'XYZ']}
pos ← {⍺⍸⍵[⍸⍵∊⍺]}
strat ← 3 3 ⍴ 2 1 3 3 2 1 1 3 2
plays ← {(⍳3)+.×+/('ABC' pos ⍵)(=⍤1 1)strat[⍳3;'XYZ' pos ⍵]}
score ← {+/(results ⍵)(plays ⍵)}
score input
