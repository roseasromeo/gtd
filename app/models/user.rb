class User < ApplicationRecord
  validates :email, :name, :password_digest, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, confirmation: { case_sensitive: true }

  has_many :inboxes, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :checklists, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :print_checklists, dependent: :destroy

  before_save { |user| user.email = email.downcase }

  has_secure_password

  after_initialize do
    unless persisted?
      inboxes << Inbox.new(name: 'General', user: self, deletable: false, description: "If you decide to use this app as a single Digital Inbox, add all items to this Bin. If you decide to place items in many Bins before processing them into Tasks/Projects/etc., this Bin should be used for any items that don't fit in the other Bins you've made.")
      inboxes << Inbox.new(name: 'Someday/Maybe', user: self, deletable: false, description: "A place to put all items that should be revisited at another point in time or under different circumstances. Most items will start in another Bin and get moved here during processing. We recommend revisiting the items in this bin occasionally to see if they become relevant or can be deleted.")
      folders << Folder.new(name: 'General Reference', user: self, deletable: false)
      projects << Project.new(name: 'Unassigned', user: self, deletable: false)
      projects << Project.new(name: 'Single Step', user: self, deletable: false)
      locations << Location.new(name: 'Anywhere', user: self, deletable: false)
      checklists << Checklist.new(name: 'Waiting On', description: "For things that you are waiting on other people for.", user: self, deletable: false)
    end
  end

end
