class Attendee < ActiveRecord::Base
  has_many :attendences
end
