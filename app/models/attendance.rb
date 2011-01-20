class Attendance < ActiveRecord::Base
  belongs_to :attendee

  validates_uniqueness_of :attendee_id, :scope => :date

end
