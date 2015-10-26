class User < ActiveRecord::Base
  validates_presence_of :mail, :password
end
