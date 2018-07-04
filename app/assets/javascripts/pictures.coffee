# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  canvas = $('#draw-area')
  user_id = $('#user_id').attr("value")
  chat_room = $('#chat_room').attr("value")
  pict_num = $('#picture_number').attr("value")
  console.log 'hello'
  ctx = canvas[0].getContext('2d')
  ctx.lineWidth = 1

  ctx.putPoint = (x, y)->
    @.beginPath()
    @.arc(x, y, @.lineWidth / 2.0, 0, Math.PI*2, false)
    @.fill()
    @.closePath()
  ctx.drawLine = (sx, sy, ex, ey)->
    @.beginPath()
    @.moveTo(sx, sy)
    @.lineTo(ex, ey)
    @.stroke()
    @.closePath()
  ctx.setColor = ->
    color = "rgb(#{red_slider.val()},#{green_slider.val()},#{blue_slider.val()})"
    @.strokeStyle = color
    @.fillStyle = color
    preview_color.css('background-color', color)
  ctx.savePrevData = ->
    @.prevImageData = @.getImageData(0, 0, canvas.width(), canvas.height())

  mousedown = false

  canvas.mousedown (e)->
    ctx.savePrevData()
    # removed by I.K. 2018/07/02 -- from here
    # ctx.prevPos = getPointPosition(e)
    # ctx.putPoint(ctx.prevPos.x, ctx.prevPos.y)
    # ctx.beginPath()
    # ctx.moveTo(ctx.prevPos.x, ctx.prevPos.y)
    # position = { prex: ctx.prevPos.x, prey: ctx.prevPos.y, act: 'down'}
    # App.room.speak(position)
    # removed by I.K. 2018/07/02  -- to here
    mousedown = true
    pos = getPointPosition(e)
    data = { x: pos.x, y: pos.y, act: 'down'}
    ctx.beginPath()
    ctx.moveTo(pos.x, pos.y)
    App.room.draw(data)

  canvas.mousemove (e)->
    return unless mousedown
    # removed by I.K. 2018/07/02 -- from here
    # nowPos = getPointPosition(e)
    # ctx.putPoint(nowPos.x, nowPos.y)
    # ctx.prevPos = nowPos
    # ctx.lineTo(nowPos.x, nowPos.y)
    # ctx.stroke()
    # position = { prex: ctx.prevPos.x, prey: ctx.prevPos.y, nposx: nowPos.x, nposy: nowPos.y, act: 'move' }
    # App.room.speak(position)
    # removed by I.K. 2018/07/02  -- to here
    pos = getPointPosition(e)
    ctx.lineTo(pos.x, pos.y)
    ctx.stroke()
    data = { x: pos.x, y: pos.y, act: 'move'}
    App.room.draw(data)

  canvas.mouseup (e)->
    mousedown = false
    # removed by I.K. 2018/07/02 -- from here
    # ctx.prevPos = getPointPosition(e)
    # ctx.lineTo(ctx.prevPos.x, ctx.prevPos.y)
    # ctx.stroke()
    # position = {prex: ctx.prevPos.x, prey: ctx.prevPos.y, act: 'up'}
    # App.room.speak(position)
    # removed by I.K. 2018/07/02  -- to here
    pos = getPointPosition(e)
    ctx.lineTo(pos.x, pos.y)
    ctx.stroke()
    color = "rgb(#{red_slider.val()},#{green_slider.val()},#{blue_slider.val()})"
    data = { x: pos.x, y: pos.y, col: color, user: user_id, chat_room: chat_room, pict_num: pict_num, width: ctx.lineWidth, act: 'up'}
    App.room.draw(data)

  canvas.mouseout (e)->
    mousedown = false
    #ctx.prevPos = getPointPosition(e)
    #ctx.lineTo(ctx.prevPos.x, ctx.prevPos.y)
    #ctx.stroke()
    # removed by I.K. 2018/07/02 -- from here
    # position = {act: 'out'}
    # App.room.draw(position)
    # removed by I.K. 2018/07/02  -- to here
    data = {act: 'out'}
    App.room.draw(data)

  getPointPosition = (e)->
    {x: e.pageX-canvas.offset().left-2, y: e.pageY-canvas.offset().top-2}

  $("#pen-width-slider").change ->
    ctx.lineWidth = $(@).val()
    $("#show-pen-width").text(ctx.lineWidth)

  red_slider = $("#pen-color-red-slider")
  green_slider = $("#pen-color-green-slider")
  blue_slider = $("#pen-color-blue-slider")
  preview_color = $("#preview-color")

  red_slider.change ->
    ctx.setColor()
    $("#show-pen-red").text($(@).val())
  green_slider.change ->
    ctx.setColor()
    $("#show-pen-green").text($(@).val())
  blue_slider.change ->
    ctx.setColor()
    $("#show-pen-blue").text($(@).val())

  $("#clear-button").click ->
    ctx.clearRect(0, 0, canvas.width(), canvas.height())

  $("#save-button").click ->
    url = canvas[0].toDataURL()
    $.post '/pictures', {data: url}, (data)->
      reloadPictures()

  $("#return-button").click ->
    ctx.putImageData(ctx.prevImageData, 0, 0)

  controll_buttons = $("#controll-panel .controll-button")
  controll_buttons.mouseenter ->
    $(@).addClass('button-over')
  controll_buttons.mouseout ->
    $(@).removeClass('button-over')

  reloadPictures = ->
    $.get '/pictures', (result)->
      ids = result.split(',')
      pictures = $("#pictures")
      pictures.empty()
      ids.forEach (id, i)->
        if parseInt(id) > 0
          pictures.append("<img src=\"/images/#{id}.png\" class=\"thumbnail\" />")
      thumb_pics = $("#pictures .thumbnail")
      thumb_pics.click ->
        image = new Image()
        image.src = $(@).attr('src')
        image.onload = ->
          ctx.clearRect(0, 0, canvas.width(), canvas.height())
          ctx.drawImage(image, 0, 0)
      thumb_pics.mouseenter ->
        $(@).addClass('thumbnail-over')
      thumb_pics.mouseout ->
        $(@).removeClass('thumbnail-over')

  reloadPictures()
