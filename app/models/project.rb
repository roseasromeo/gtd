class Project < ApplicationRecord
  belongs_to :user

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
