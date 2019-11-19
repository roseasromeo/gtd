class AddModeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :mode, :boolean, default: false, null: false
  end
end
