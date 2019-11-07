class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :name
      t.belongs_to :user, foreign_key: true, null: false
      t.boolean :deletable, default: true

      t.timestamps
    end
  end
end
