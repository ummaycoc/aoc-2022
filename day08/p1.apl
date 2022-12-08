fname ← '/path/to/file'
read ← 'UTF-8' ⎕NGET fname
input ← ¯1↓⊃read[1]
grid ← ⍎¨↑{⍵⊆⍨~⍵=⎕UCS 10} input
v ← {(⍺⍺⍣¯1)2</¯1,⌈\⍺⍺⍵}
+/∊{∨/(⊢v⍵)(⌽v⍵)(⍉v⍵)((⌽⍉)v⍵)} grid
