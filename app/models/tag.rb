class Tag < ApplicationRecord
  belongs_to :user
  has_many :tag_tasks, dependent: :destroy
  has_many :tasks, through: :tag_tasks
  validates_with NameValidator
end
