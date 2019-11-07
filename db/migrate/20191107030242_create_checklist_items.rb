class CreateChecklistItems < ActiveRecord::Migration[5.2]
  def change
    create_table :checklist_items do |t|
      t.string :name
      t.belongs_to :checklist, foreign_key: true, null: false

      t.timestamps
    end
  end
end
