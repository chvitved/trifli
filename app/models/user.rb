class User < ActiveRecord::Base
  has_many :attendances
end
