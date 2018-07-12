class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update, :destroy]
   
  # GET /participants
  # GET /participants.json
  def index
    Participant.delete_all
    @users= User.order("id ASC")
    @chat_rooms=ChatRoom.order("id ASC")
    @chats=Chat.all
    @strokes=Stroke.all
    @now_time=Time.now
    @chat_border=5*60 #5 minutes
    @login_border=30*60 #30 minutes
    @users.each do |user|
      @online=false
      @chat_rooms.each do |chat_room|   
        @create=false           
        #latest chat and stroke in one chat_room
        if(@chats!=nil)
          @latest_chat=@chats.where(user_id:user.id).where(chat_room_id:chat_room.id).last
        end
        if(@strokes!=nil)
          @latest_stroke=@strokes.where(user_id:user.id).where(chat_room_id:chat_room.id).last
        end
        if(@latest_chat!=nil)then
          #if user chat or stroke in 5 minutes
          if(@now_time-@latest_chat.created_at<@chat_border && @create==false)
            Participant.create(user: user,chat_room: chat_room)
            @online=true
            @create=true
          end
        end
        if(@latest_stroke!=nil)
          if(@now_time-@latest_stroke.created_at<@chat_border && @create=false)then
            Participant.create(user: user,chat_room: chat_room)
            @online=true
            @create=true
          end
        end
      end
      #if user sign in around 30 minutes
      if(@online==false && @now_time-user.current_sign_in_at<@login_border) 
        @online=true
      end
      user.update(online: @online)
    end
  end

  # GET /participants/1
  # GET /participants/1.json
  def show
  end

  # GET /participants/new
  def new
    @participant = Participant.new
  end

  # GET /participants/1/edit
  def edit
  end

  # POST /participants
  # POST /participants.json
  def create
    @participant = Participant.new(participant_params)

    respond_to do |format|
      if @participant.save
        format.html { redirect_to @participant, notice: 'Participant was successfully created.' }
        format.json { render :show, status: :created, location: @participant }
      else
        format.html { render :new }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participants/1
  # PATCH/PUT /participants/1.json
  def update
    respond_to do |format|
      if @participant.update(participant_params)
        format.html { redirect_to @participant, notice: 'Participant was successfully updated.' }
        format.json { render :show, status: :ok, location: @participant }
      else
        format.html { render :edit }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participants/1
  # DELETE /participants/1.json
  def destroy
    @participant.destroy
    respond_to do |format|
      format.html { redirect_to participants_url, notice: 'Participant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def self.create_records
    @users= User.order("id ASC")
    @chat_rooms=ChatRoom.order("id ASC")
    @chats=Chat.order("id ASC")
    @strokes=Stroke.order("id ASC")
    @now_time=Time.now
    @chat_border=5*60 #5 minutes
    @login_border=30*60 #30 minutes
    @users.each do |user|
      @online=false
      @caht_rooms.each do |chat_room|
        #latest chat and stroke in one chat_room
        @latest_chat=@chats.where(user:user.id).where(chat_room:chat_room.id).last
        @latest_stroke=@stroke.where(user:user.id).where(chat_room:chat_room.id).last
        if(@latest_chat!=nil || @latest_stroke!=nil)then
          #if user chat or stroke in 5 minutes
          if(@now_time-@latest_chat.created_at<@chat_border || @now_time-@latest_stroke.created_at<@chat_border)then
            Participant.create(user: user,chat_room: chat_room)
            @online=true
          end
        end
      end
      #if user sign in around 30 minutes
      if(@online==false && @now_time-user.current_sign_in_at<@login_border) 
        @online=true
      end
      user.update(online: @online)
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_participant
      @participant = Participant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def participant_params
      params.require(:participant).permit(:user_id, :chat_room_id)
    end
end