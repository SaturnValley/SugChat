$(document).ready ->
  remote_canvas = $('#draw-area')
  remote_ctx = remote_canvas[0].getContext('2d')
  remote_ctx.lineWidth = 1
  remote_down = false

  remote_ctx.putPoint = (x, y)->
    @.beginPath()
    @.arc(x, y, @.lineWidth / 2.0, 0, Math.PI*2, false)
    @.fill()
    @.closePath()

  remote_ctx.drawLine = (sx, sy, ex, ey)->
    @.beginPath()
    @.moveTo(sx, sy)
    @.lineTo(ex, ey)
    @.stroke()
    @.closePath()

  remote_ctx.savePrevData = ->
    @.prevImageData = @.getImageData(0, 0, remote_canvas.width(), remore_canvas.height())

  App.room = App.cable.subscriptions.create "RoomChannel",
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      switch data.room.position.act
        when 'down'
          remote_ctx.savePrevData()
          remote_down = true
          remote_ctx.beginPath()
          remote_ctx.moveTo(data.room.position.prex, data.room.position.prey)
          # remote_ctx.putPoint(data.battle.position.prex, data.battle.position.prey)
        when 'move'
          return unless remote_down
          remote_ctx.lineTo(data.room.position.nposx, data.room.position.nposy)
          remote_ctx.stroke()
          #remote_ctx.drawLine(data.battle.position.prex, data.battle.position.prey, data.battle.position.nposx, data.battle.position.nposy)
          #remote_ctx.putPoint(data.battle.position.nposx, data.battle.position.nposy)
        when 'up'
          remote_ctx.lineTo(data.room.position.prex, data.room.position.prey)
          remote_ctx.stroke()
          remote_ctx.closePath()
          remote_down = false
        when 'out'
          #remote_ctx.lineTo(data.battle.position.prex, data.battle.position.prey)
          #remote_ctx.stroke()
          remote_ctx.closePath()
          remote_down = false

      # Called when there's incoming data on the websocket for this channel

    speak: (position)->
      @perform 'speak', position: position
