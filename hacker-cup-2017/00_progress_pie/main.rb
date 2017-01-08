class Pixel
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def pi
    Math::PI
  end

  def radius
    Math.sqrt(x**2 + y**2)
  end

  def percentage
    ang = (Complex(x, y) * 1i ** 3).angle

    per =
      if ang > 0
        (ang.abs / pi) / 2
      else
        ((ang + pi) / pi / 2) + 0.5
      end

    100 - (per * 100).floor
  end
end

class ProgressPie
  attr_reader :prog, :radius

  def initialize(prog, radius)
    @prog = prog
    @radius = radius
  end

  def contain?(pixel)
    return false if prog == 0
    pixel.radius <= radius && pixel.percentage <= prog
  end
end

gets.to_i.times do |i|
  p, x, y = gets.split.map(&:to_i)

  pixel = Pixel.new(x - 50, y - 50)
  contain = ProgressPie.new(p, 50).contain?(pixel)

  puts format('Case #%d: %s', i + 1, contain ? 'black' : 'white')
end

