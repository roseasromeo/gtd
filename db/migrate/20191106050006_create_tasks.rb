class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.belongs_to :project, foreign_key: true, null: false
      t.belongs_to :location, foreign_key: true, null: false
      t.string :name
      t.text :description
      t.integer :time
      t.integer :energy
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
