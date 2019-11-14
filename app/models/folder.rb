class Folder < ApplicationRecord
  belongs_to :user
  validates_with NameValidator

  has_many :ref_items, dependent: :destroy
end
