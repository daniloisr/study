require 'scanf'

$memo = {}

# ref: http://stackoverflow.com/a/31884942/1042324
def prob(h, x, y)
  return 0 if h < x
  combined_probs = $memo[[x,y]]

  if combined_probs.nil?
    combined_probs = [1]

    x.times do
      start_probs = combined_probs
      combined_probs = []
      start_probs.each_with_index do |prob_a, ia|
        y.times do |ib|
          combined_probs[ia + ib] = (combined_probs[ia + ib] || 0) + prob_a
        end
      end
    end

    $memo[[x,y]] = combined_probs
  end

  probs = combined_probs[0..(h - x)].map { |i| i || 0 }
  (1.0 * probs.reduce(&:+)) / (y ** x)
end

gets.to_i.times do |i|
  h, _ = gets.split.map(&:to_i)
  dice = gets.split.map { |die| die.scanf('%dd%d%d') }
  probs = dice.map do |x, y, hi|
    to_roll = hi ? (h - hi) : h

    1.0 - prob(to_roll - 1, x, y).round(6)
  end

  puts format('Case %d: %.6f', i+1, probs.max)
end
