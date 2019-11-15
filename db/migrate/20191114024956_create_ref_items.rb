class CreateRefItems < ActiveRecord::Migration[5.2]
  def change
    create_table :ref_items do |t|
      t.string :name
      t.text :description
      t.belongs_to :folder, foreign_key: true, null: false

      t.timestamps
    end
  end
end
