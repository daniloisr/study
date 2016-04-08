class Hamming
  def self.compute(s, t)
    [s.size, t.size].min.times.count {|i| s[i] != t[i] }
  end
end