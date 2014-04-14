canvas = document.querySelector('canvas')
ctx = canvas.getContext('2d')

canvas.style.width = canvas.width = w = 800
canvas.style.height = canvas.height = h = 600

# block size
s = 2


hslToRgb = (h, s, l) ->
  c = (1 - Math.abs(2*l - 1)) * s

  h1 = h / 60
  x = c * (1 - Math.abs(h1%2 - 1))
  rgb = switch
    when h1 < 1 then [c, x, 0]
    when h1 < 2 then [x, c, 0]
    when h1 < 3 then [0, c, x]
    when h1 < 4 then [0, x, c]
    when h1 < 5 then [x, 0, c]
    when h1 < 6 then [c, 0, x]
    else [0, 0, 0]

  m = l - c/2
  [rgb[0] + m, rgb[1] + m, rgb[2] + m]


# get pixel color from canvas
getPixelColor = (ctx, x, y) ->
  # Get the CanvasPixelArray from the given coordinates and dimensions.
  imgd = ctx.getImageData(x, y, 1, 1)
  pix = imgd.data

  [pix[0], pix[1], pix[2], pix[3]]



# given a color in array4 returns the hex color format
hexColor = (ary) ->
  ary.map((i) -> i.toString(16)).join('')

# Main
for i in [0..h] by s
  for j in [0..w] by s
    rgb = hslToRgb(j * 360/w, i/h, 1.0 - i/h)
    rgb = rgb.map((i) -> Math.floor(i * 255))
    ctx.fillStyle = "rgb(#{rgb.join(',')})"
    ctx.fillRect(j, i, s, s)

ctxMove = (e) ->
  colorOver = document.getElementById('#colorOver')

  unless colorOver?
    colorOver = document.createElement('div')
    colorOver.id = '#colorOver'
    document.body.appendChild(colorOver)

  colorOver.innerHTML = hexColor(getPixelColor(ctx, e.x, e.y))

canvas.addEventListener('mousemove', ctxMove)

# links
# http://en.wikipedia.org/wiki/HSL_and_HSV#Hue_and_chroma
# http://www.rapidtables.com/convert/color/rgb-to-hsl.htm
# http://stackoverflow.com/questions/667045/getpixel-from-html-canvas
