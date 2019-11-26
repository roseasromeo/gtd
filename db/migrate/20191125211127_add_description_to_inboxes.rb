class AddDescriptionToInboxes < ActiveRecord::Migration[5.2]
  def change
    add_column :inboxes, :description, :text
  end
end
