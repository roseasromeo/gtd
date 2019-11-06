class CreateTagTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_tasks do |t|
      t.belongs_to :tag, foreign_key: true, null: false
      t.belongs_to :task, foreign_key: true, null: false

      t.timestamps
    end
  end
end
