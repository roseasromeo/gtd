class Location < ApplicationRecord
  belongs_to :user
  validates :name, uniqueness: { case_sensitive: false }

  has_many :tasks, dependent: :destroy
end
