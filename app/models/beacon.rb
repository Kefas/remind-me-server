class Beacon < ActiveRecord::Base
  has_many :reminds
  has_and_belongs_to_many :users
end
