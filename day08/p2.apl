fname ← '/path/to/file'
read ← 'UTF-8' ⎕NGET fname
input ← ¯1↓⊃read[1]
grid ← ⍎¨↑{⍵⊆⍨~⍵=⎕UCS 10} input
indices ← ⍳⍴grid
cross ← {indices[⍺;],indices[;⍵]}
split ← {c←↑⍺ cross ⍵ ⋄ {grid[⍵]}¨↓¨(⊖c[⍸⍵>c[;2];])(c[⍸⍵<c[;2];])(⊖c[⍸⍺>c[;1];])(c[⍸⍺<c[;1];])}
view ← {(∧\grid[⍺;⍵]∘>)¨⍺ split ⍵}
count ← {v←(+/∧\)¨⍺ view ⍵ ⋄ n←⊃⍴grid ⋄ v+(1(-n)1(-n))<(⍵(-⍵)⍺(-⍺))-v}
⌈/∊(⊢∘.{×/⍺ count ⍵}⊣)⍳⊃⍴grid
