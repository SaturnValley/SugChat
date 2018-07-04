class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(stroke)
    ActionCable.server.broadcast "room_channel", room: stroke
  end

  def draw(data)
    param = data["data"]
    case param["act"]
    when "down"
      @sequence = Array[param["x"], param["y"] ]
    when "move"
      @sequence.push(param["x"], param["y"])
    when "up"
      @sequence.push(param["x"], param["y"])
      stroke_param = {
        :sequence => @sequence.join(','), # => "1,2,5,10,...,3,5"
        :color => param["col"], # => "rgb(128,0,255)"
        :user_id => param["user"],
        :chat_room_id => param["chat_room"],
        :picture_number => param["pict_num"],
        :width => param['width']
      }
      speak(stroke_param)
      stroke = Stroke.new(stroke_param)
      stroke.save
    end
    # ActionCable.server.broadcast "room_channel", room: action
  end

end
