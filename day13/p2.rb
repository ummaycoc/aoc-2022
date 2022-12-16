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

class Object
  def singleton?
    self.is_a?(Array) && self.length == 1
  end
end    

packets = File.readlines('input').reject {|l|
  l =~ /^\s*$/
}.map {|l|
  eval(l)
} << [[2]] << [[6]]
packets.sort! {|a, b| catch(:compared) {compare(a, b)} || 0}
puts packets.each_with_index.select {|packet, i|
  packet.singleton? && packet[0].singleton? && [2, 6].include?(packet[0][0])
}.map {|packet, i|
  i + 1
}.inject(1) {|l, r| l * r}
