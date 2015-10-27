class Remind < ActiveRecord::Base
  belongs_to :user
  belongs_to :beacon
end
