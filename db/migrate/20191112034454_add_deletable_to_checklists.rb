class AddDeletableToChecklists < ActiveRecord::Migration[5.2]
  def change
    add_column :checklists, :deletable, :boolean, null: false, default: true
  end
end
