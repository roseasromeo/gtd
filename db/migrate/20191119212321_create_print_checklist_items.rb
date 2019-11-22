class CreatePrintChecklistItems < ActiveRecord::Migration[5.2]
  def change
    create_table :print_checklist_items do |t|
      t.string :name
      t.boolean :completed, null: false, default: false
      t.belongs_to :print_checklist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
