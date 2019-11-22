class CreatePrintChecklists < ActiveRecord::Migration[5.2]
  def change
    create_table :print_checklists do |t|
      t.string :name
      t.text :description
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
