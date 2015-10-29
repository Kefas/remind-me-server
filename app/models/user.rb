class User < ActiveRecord::Base
  validates_presence_of :mail, :password
  validates_uniqueness_of :mail
  has_many :reminds
end
