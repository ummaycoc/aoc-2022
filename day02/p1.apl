name ← '/path/to/file'
read ← 'UTF-8' ⎕NGET fname
input ← ¯1↓⊃read[1]
choices ← {(⍳3)+.×2⌷[2]((⊂⍋)⌷⊣)({⍺,≢⍵}⌸)⍵[⍸⍵∊'XYZ']}
pos ← {⍺⍸⍵[⍸⍵∊⍺]}
draws ← {+/('XYZ' pos ⍵)=('ABC' pos ⍵)}
wins ← {+/(1+3|1+'XYZ' pos ⍵)=('ABC' pos ⍵)}
score ← {1 3 6 +.× (choices ⍵) (draws ⍵) (wins ⍵)}
score input
