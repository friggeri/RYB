RYB = 
  white:  [1,1,1]
  red:    [1,0,0]
  yellow: [1,1,0]
  blue:   [0.163,0.373,0.6]
  violet: [0.5,0,0.5]
  green:  [0,0.66,0.2]
  orange: [1,0.5,0]
  black:  [0.2,0.094,0.0]
  
  rgb: (ryb...) ->
    [r,y,b] = ryb.map (t) -> t*t*(3-2*t)
    
    for i in [0..2]
      RYB.white[i]  * (1-r) * (1 - b) * (1 - y) + 
      RYB.red[i]    *    r  * (1 - b) * (1 - y) + 
      RYB.blue[i]   * (1-r) *      b  * (1 - y) + 
      RYB.violet[i] *    r  *      b  * (1 - y) +
      RYB.yellow[i] * (1-r) * (1 - b) *      y  + 
      RYB.orange[i] *     r * (1 - b) *      y  + 
      RYB.green[i]  * (1-r) *      b  *      y  + 
      RYB.black[i]  *     r *      b  *      y  

generate     = document.getElementById('generate')
numberColors = document.getElementById('number-colors')
display      = document.getElementById('colors')

generate.addEventListener 'click', (event) ->
  event.preventDefault()
  
  display.removeChild display.firstChild while display.firstChild
  
  number = parseInt(numberColors.value, 10)
  base   = Math.ceil(Math.pow(number, 1/3))
  
  for n in [0...number]
    [r,g,b] = RYB.rgb(
      Math.floor( n / (base*base) ) / (base-1), 
      Math.floor( n / base % base ) / (base-1), 
      Math.floor( n % base        ) / (base-1)
    ).map((x) -> Math.floor(255*x))
    
    el = document.createElement "div"
    el.setAttribute "class", "color"
    el.style.backgroundColor = "rgb(#{r}, #{g}, #{b})"
    display.appendChild el
  