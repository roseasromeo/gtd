class Task < ApplicationRecord
  belongs_to :project
  belongs_to :location

  has_many :tag_tasks, dependent: :destroy
  has_many :tags, through: :tag_tasks

  accepts_nested_attributes_for :tag_tasks, :allow_destroy => true

  enum time: { five_min: 5, fifteen_min: 15, thirty_min: 30, fortyfive_min: 45, one_hr: 60, one_hr_thirty_min: 90, two_hr: 120, two_hr_thirty_min: 150, three_hr: 180, four_hr: 240 }

  enum energy: [:low, :medium, :high]

  def self.time_name(time)
    tn = { five_min: 5, fifteen_min: 15, thirty_min: 30, fortyfive_min: 45, one_hr: 60, one_hr_thirty_min: 90, two_hr: 120, two_hr_thirty_min: 150, three_hr: 180, four_hr: 240 }
    tn.key(time)
  end

  def self.time_names
    #time_names = { five_min: "5 min", fifteen_min: "15 min", thirty_min: "30 min", fortyfive_min: "45 min", one_hr: "1 hr", one_hr_thirty_min: "1 hr 30 min", two_hr: "2 hr", two_hr_thirty_min: "2 hr 30 min", three_hr: "3 hr", four_hr: "4 hr" }
    time_names = { "5 min" => 5, "15 min" => 15, "30 min" => 30, "45 min" => 45, "1 hr" => 60, "1 hr 30 min" => 90, "2 hr" => 120, "2 hr 30 min" => 150, "3 hr" => 180, "4 hr" => 240}
  end

  def complete
    self.update_attributes(completed: true)
  end

  def uncomplete
    self.update_attributes(completed: false)
  end
end
