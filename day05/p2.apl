fname ← '/path/to/file'
read ← 'UTF-8' ⎕NGET fname
input ← ¯1↓⊃read[1]
lines ← {⍵⊆⍨~⍵=⎕UCS 10}input
stacks ← ↑lines[⍸'['(∊⍤1 1)↑lines]
nstacks ← ⌈/⍎lines⊃⍨1+≢stacks
stacks ← {⍵~' '}¨↓⍉stacks[;2+4×¯1+⍳9]
stacks ← nstacks ⍴ stacks,nstacks⍴⊂''
moves ← {⍎⍵[⍸⍵∊⎕D,' ']}¨lines[⍸'move'≡(⍤1 1)(↑lines)[;⍳4]]
update ← {st a s d←(⊂⍵),⍺ ⋄ st[d s]←((a↑s⊃st),(d⊃st))(a↓s⊃st) ⋄ st}
∊(1∘↑)¨⊃update/(⌽moves),⊂stacks
