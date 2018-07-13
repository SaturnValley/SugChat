class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :edit, :update, :destroy]

  # GET /chats
  # GET /chats.json
  def index
    @search_chats = Chat.ransack(params[:q])
    @chats = @search_chats.result(distinct: true).page(params[:page]).per(10)

    # chat_rooms contains only chat_rooms that removed field is nil by default
    @search_rooms = ChatRoom.where(removed: nil).ransack(params[:p], search_key: :p)
    @chat_rooms = @search_rooms.result(distinct: true).page(params[:page]).per(5)

    # users_id contains only users.id who have ever posted chat even once in all @chats
    @users_id = search_users_id_in_chats(@chats)
    @users = User.where(id: @users_id)

    render :layout => "chats_layout"
  end

  def chat_search
    @q = Chat.search(search_chat_params)
    @chats = @q.result(distinct: true)
  end

  def room_search
    @p = ChatRoom.search(search_room_params)
    @chat_rooms = @p.result(distinct: true)
  end

  # GET /chats/1
  # GET /chats/1.json
  def show
    @chat = Chat.find(params[:id])
    @user_id = search_users_id_in_chats(@chat)
    @chat_room_id = search_rooms_id_in_chats(@chat)
    @user = User.find(@user_id)
    @chat_room = ChatRoom.find(@chat_room_id)
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats
  # POST /chats.json
  def create
    @chat = Chat.new(chat_params)

    respond_to do |format|
      if @chat.save
        format.html { redirect_to @chat, notice: 'Chat was successfully created.' }
        format.json { render :show, status: :created, location: @chat }
      else
        format.html { redirect_to "/chat_rooms" }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chats/1
  # PATCH/PUT /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to @chat, notice: 'Chat was successfully updated.' }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1
  # DELETE /chats/1.json
  def destroy
    @chat.destroy
    respond_to do |format|
      format.html { redirect_to chats_url, notice: 'Chat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def search_users_id_in_chats(chats)
      users_id = []
      if !chats.kind_of?(Array)
        chats = Array(chats)
      end
      chats.each do |chat|
        if !users_id.include?(chat.user_id)
          users_id.push(chat.user_id.to_i)
        end
      end

      if users_id.length == 0
        return nil
      elsif users_id.length == 1
        return users_id[0]
      else
        return users_id
      end
    end

    def search_rooms_id_in_chats(chats)
      chat_rooms_id = []
      if !chats.kind_of?(Array)
        chats = Array(chats)
      end
      chats.each do |chat|
        if !chat_rooms_id.include?(chat.chat_room_id)
          chat_rooms_id.push(chat.chat_room_id.to_i)
        end
      end
      if chat_rooms_id.length == 0
        return nil
      elsif chat_rooms_id.length == 1
        return chat_rooms_id[0]
      else
        return chat_rooms_id
      end
    end

    def set_chat
      @chat = Chat.find(params[:id])
    end

    def search_chat_params
      params.require(:q).permit(:chat_room_id, :message)
    end

    def search_room_params
      params.require(:p).permit(:name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chat_params
      params.require(:chat).permit(:chat_room_id, :message, :user_id)
    end
end
