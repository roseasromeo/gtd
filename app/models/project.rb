class Project < ApplicationRecord
  belongs_to :user
  validates :name, uniqueness: { case_sensitive: false }

  has_many :tasks, dependent: :destroy

  def archive
    if self.deletable?
      self.update_attributes(archived: true)
    end
  end

  def unarchive
    self.update_attributes(archived: false)
  end

end
