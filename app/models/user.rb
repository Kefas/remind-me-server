class User < ActiveRecord::Base
  validates_presence_of :mail, :password
  validates_uniqueness_of :mail
  has_many :reminds
  has_and_belongs_to_many :beacons
end
