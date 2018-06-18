# 6:    [1, 2, 3]
#       [2, 3]
# 12:   [1, 2, 3, 4]
#       [1, 2, 3, 2]
# 60:   [1, 2, 3, 4, 5, 6]
#       [1, 2, 3, 2, 5, 1]
# 420:  [1, 2, 3, 4, 5, 6, 7]
#       [1, 2, 3, 2, 5, 1, 7]
# 1680: [1, 2, 3, 4, 5, 6, 7, 8]
#       [1, 2, 3, 2, 5, 1, 7, 2]
# 2520: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
#       [1, 2, 3, 2, 5, 1, 7, 2, 3, 1]

n = 20
primes = {}
(1..n).each do |i|
  i.prime_division.each do |(prime, count)|
    primes[prime] = [primes[prime] || 0, count].max
  end
end

puts primes.reduce(1) { |memo, (prime, times)| memo * prime**times }
