class AddColumnToStroke < ActiveRecord::Migration[5.2]
  def change
    add_column :strokes, :width, :integer
  end
end
