class User < ActiveRecord::Base
  validates_presence_of :mail, :password
  has_many :reminds
end
