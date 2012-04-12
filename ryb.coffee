cbrt = (x) -> 
  (if x < 0 then - 1 else 1) * Math.pow(Math.abs(x), 1/3)

RYB = 
  white:  [1,1,1]
  red:    [1,0,0]
  yellow: [1,1,0]
  blue:   [0.163,0.373,0.6]
  violet: [0.5,0,0.5]
  green:  [0,0.66,0.2]
  orange: [1,0.5,0]
  black:  [0.2,0.094,0.0]
  
  rgb: (r, y, b) ->
    for i in [0..2]
      RYB.white[i]  * (1-r) * (1 - b) * (1 - y) + 
      RYB.red[i]    *    r  * (1 - b) * (1 - y) + 
      RYB.blue[i]   * (1-r) *      b  * (1 - y) + 
      RYB.violet[i] *    r  *      b  * (1 - y) +
      RYB.yellow[i] * (1-r) * (1 - b) *      y  + 
      RYB.orange[i] *     r * (1 - b) *      y  + 
      RYB.green[i]  * (1-r) *      b  *      y  + 
      RYB.black[i]  *     r *      b  *      y

class Points extends Array
  constructor: (number) ->
    base  = Math.ceil(Math.pow(number, 1/3))
    @push [
      Math.floor( n / (base*base) ) / (base-1), 
      Math.floor( n / base % base ) / (base-1), 
      Math.floor( n % base        ) / (base-1)
    ] for n in [0...Math.pow(base, 3)]
    @picked  = null
    @plength = 0
  
  distance: (p1) ->
    [0..2].map((i) => Math.pow(p1[i] - @picked[i], 2)).reduce((a,b) -> a+b)
    
  pick: () ->
    unless @picked?
      pick = @picked  = @shift()
      @plength = 1
    else
      [index, _] = @reduce ([i1, d1], p2, i2) =>
        d2 = @distance(p2)
        if d1 < d2 then [i2, d2] else [i1, d1]
      , [0, @distance(this[0])]
      pick = @splice(index, 1)[0]
      @picked = [0..2].map((i) => (@plength * @picked[i] + pick[i])/(@plength+1))
      @plength++
    return pick

generate     = document.getElementById('generate')
numberColors = document.getElementById('number-colors')
display      = document.getElementById('colors')

generateColors = () ->
  display.removeChild display.firstChild while display.firstChild
  
  number = parseInt(numberColors.value, 10)
  
  points = new Points(number)
  point  = null
  for i in [1..number]
    point = points.pick(point)
    [r,g,b] = RYB.rgb(point...).map((x) -> Math.floor(255*x))
    color = "rgb(#{r}, #{g}, #{b})"
    
    el = document.createElement "div"

    el.setAttribute "class", "color"
    el.setAttribute "title", color
    el.style.backgroundColor = color
    display.appendChild el

generate.addEventListener 'click', generateColors
numberColors.addEventListener 'input', generateColors
numberColors.addEventListener 'submit', generateColors

generateColors()