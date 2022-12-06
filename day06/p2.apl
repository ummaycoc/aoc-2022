fname ← '/path/to/file'
read ← 'UTF-8' ⎕NGET fname
input ← ¯1↓⊃read[1]
13+14⍳⍨≢¨14∪/input
