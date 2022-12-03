fname ← '/path/to/file'
read ← 'UTF-8' ⎕NGET fname
input ← ¯1↓⊃read[1]
p ← ∊∪¨∩/{(3÷⍨≢⍵) 3⍴⍵}{⍵⊆⍨~(⎕UCS 10)=⍵} input
idx ← {⍵⍸p[⍸p∊⍵]}
+/(idx ⎕UCS 96 + ⍳26),(26 + idx ⎕A)
