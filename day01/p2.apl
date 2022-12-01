fname ← '/path/to/file'
read ← 'UTF-8' ⎕NGET fname
input ← ¯1↓⊃read[1]
elves ← {⍵⊆⍨~0,1<2+/(⎕UCS 10)=⍵}
calories ← {+/⍎¨⍵⊆⍨~(⎕UCS 10)=⍵}
+/3↑((⊂⍒)⌷⊣)calories¨elves input
