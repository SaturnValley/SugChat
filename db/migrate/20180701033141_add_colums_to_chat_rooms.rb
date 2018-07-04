class AddColumsToChatRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :chat_rooms, :removed, :integer
  end
end
