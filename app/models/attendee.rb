class Attendee < ActiveRecord::Base
  has_many :attendances, :dependent => :destroy

  validates_uniqueness_of :jabber_id

  def has_answered_for_tomorrow?
    !attendances.find_by_date(Date.tomorrow).nil?
  end
end
