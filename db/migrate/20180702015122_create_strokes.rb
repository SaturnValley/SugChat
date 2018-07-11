class CreateStrokes < ActiveRecord::Migration[5.2]
  def change
    create_table :strokes do |t|
      t.string :sequence
      t.string :color
      t.integer :user_id
      t.integer :chat_room_id
      t.integer :picture_number

      t.timestamps
    end
  end
end
