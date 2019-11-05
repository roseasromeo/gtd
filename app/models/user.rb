class User < ApplicationRecord
  validates :email, :name, :password_digest, presence: true
  validates :email, :name, uniqueness: { case_sensitive: false }

  has_many :inboxes
  #has_many :items

  before_save { |user| user.email = email.downcase }

  has_secure_password
end
