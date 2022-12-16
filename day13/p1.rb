def compare(a, b)
  if a.is_a?(Integer) && b.is_a?(Integer) then
    return if a == b
    throw :compared, a <=> b
  end
  a = a.is_a?(Integer) ? [a] : a
  b = b.is_a?(Integer) ? [b] : b
  l = [a.length, b.length].min
  a[0...l].zip(b[0...l]).each {|av, bv| compare(av, bv)}
  comp = a.length <=> b.length
  throw :compared, comp unless comp == 0
end

p File.readlines('input').reject {|l|
  l =~ /^\s*$/
}.map {|l|
  eval(l)
}.each_slice(2).to_a.each_with_index.map {|(a, b), i|
  [catch(:compared) { compare(a, b) }, i]
}.select {|(c, i)|
  c == -1
}.map {|(c, i)|
  i + 1
}.inject(0) {|l, r| l + r}
