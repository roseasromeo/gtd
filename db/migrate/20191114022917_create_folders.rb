class CreateFolders < ActiveRecord::Migration[5.2]
  def change
    create_table :folders do |t|
      t.string :name
      t.text :description
      t.boolean :deletable, null: false, default: true
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
