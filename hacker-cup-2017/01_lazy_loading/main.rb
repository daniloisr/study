WEIGHT = 50

def trips_counter(items, acc = 0)
  return acc if items.empty?

  item = items.last
  ratio = (1.0 * WEIGHT / item).ceil

  return acc if ratio > items.length
  items.shift(ratio - 1) if ratio > 1

  trips_counter(items[0...-1], acc + 1)
end

gets.to_i.times do |i|
  items_count = gets.to_i
  items = items_count.times.map { gets.to_i }

  trips = trips_counter(items.sort)

  puts format('Case #%d: %d', i+1, trips)
end
