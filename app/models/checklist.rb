class Checklist < ApplicationRecord
  belongs_to :user
  has_many :checklist_items, inverse_of: :checklist, dependent: :destroy

  accepts_nested_attributes_for :checklist_items, allow_destroy: true
end
