class PrintChecklist < ApplicationRecord
  belongs_to :user
  #validates_with NameValidator
  has_many :print_checklist_items, inverse_of: :print_checklist, dependent: :destroy

  accepts_nested_attributes_for :print_checklist_items, allow_destroy: true
end
