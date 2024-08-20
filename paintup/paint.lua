local canvas = require 'paintup.canvas'
canvas.new(100, 100)

canvas.canvasRect.width = 500
canvas.canvasRect.height = 500
canvas.canvasRect.x = display.contentCenterX
canvas.canvasRect.y = display.contentCenterY

canvas.line(80, 50, 0, 10)
