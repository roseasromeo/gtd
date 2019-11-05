class CreateInboxes < ActiveRecord::Migration[5.2]
  def change
    create_table :inboxes do |t|
      t.string :name, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.boolean :deletable, default: true

      t.timestamps
    end
  end
end
