class User < ApplicationRecord
  validates :email, :name, :password_digest, presence: true
  validates :email, :name, uniqueness: { case_sensitive: false }

  has_many :inboxes, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :checklists, dependent: :destroy

  before_save { |user| user.email = email.downcase }

  has_secure_password

  after_initialize do
    unless persisted?
      inboxes << Inbox.new(name: 'General', user: self, deletable: false)
      inboxes << Inbox.new(name: 'Reference', user: self, deletable: false)
      inboxes << Inbox.new(name: 'Someday/Maybe', user: self, deletable: false)
      projects << Project.new(name: 'Unassigned', user: self, deletable: false)
      projects << Project.new(name: 'Single Step', user: self, deletable: false)
      locations << Location.new(name: 'Anywhere', user: self, deletable: false)
      checklists << Checklist.new(name: 'Waiting On', description: "For things that you are waiting on other people for.", user: self, deletable: false)
    end
  end

end
