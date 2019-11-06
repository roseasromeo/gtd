class User < ApplicationRecord
  validates :email, :name, :password_digest, presence: true
  validates :email, :name, uniqueness: { case_sensitive: false }

  has_many :inboxes, dependent: :destroy
  has_many :projects, dependent: :destroy

  before_save { |user| user.email = email.downcase }

  has_secure_password

  after_initialize do
    unless persisted?
      inboxes << Inbox.new(name: 'Default', user: self, deletable: false)
      projects << Project.new(name: 'Unassigned', user: self, deletable: false)
    end
  end

end
