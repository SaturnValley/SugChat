class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update, :destroy]
   
  # GET /participants
  # GET /participants.json
  def index
    @users= User.order("id ASC")
    @chat_rooms=ChatRoom.order("id ASC")
    @now_time=Time.now
    @chat_limit=5*60 #5 minutes
    @login_limit=30*60 #30 minutes
    #delete needless record
    Participant.where("created_at <= ?",@now_time-@chat_limit).delete_all
    @users.each do |user|
      @online=false
      @chat_rooms.each do |chat_room|
        @exist=false
        if(Participant.where(user_id:user.id).where(chat_room_id:chat_room.id)!=[])  
          @exist=true
          @online=true
        end
        if(@exist==false)
          #latest chat and stroke in one chat_room
          @latest_chat=Chat.where(user_id:user.id).where(chat_room_id:chat_room.id).where("created_at >= ?",@now_time-@chat_limit).last
          @latest_stroke=Stroke.where(user_id:user.id).where(chat_room_id:chat_room.id).where("created_at >= ?",@now_time-@chat_limit).last
          #if user chat or stroke in 5 minutes
          if(@latest_chat!=nil && @exist==false)
            Participant.create(user: user,chat_room: chat_room)
            @online=true
            @exist=true
          end
          if(@latest_stroke!=nil && @exist==false)
            Participant.create(user: user,chat_room: chat_room)
            @online=true
            @exist=true
          end
        end
      end
      #if user sign in around 30 minutes
      if(@online==false && @now_time-user.current_sign_in_at<@login_limit) 
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