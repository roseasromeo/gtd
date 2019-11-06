class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.belongs_to :user, foreign_key: true, required: true
      t.boolean :deletable, default: true
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
