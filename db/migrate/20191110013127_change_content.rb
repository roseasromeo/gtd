class ChangeContent < ActiveRecord::Migration[5.2]
  def change
    rename_column :items, :content, :description
  end
end
