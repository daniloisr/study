WEIGHT = 50

def trips_counter(items, acc = 0)
  return acc if items.empty?

  item = items.pop
  ratio = 1.0 * WEIGHT / item

  return acc if ratio > (items.length + 1)
  items.shift(ratio) if ratio > 1

  trips_counter(items, acc + 1)
end

gets.to_i.times do |i|
  items_count = gets.to_i
  items = items_count.times.map { gets.to_i }

  trips = trips_counter(items.sort)

  puts format('Case #%d: %d', i+1, trips)
end
