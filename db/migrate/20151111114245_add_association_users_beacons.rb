class AddAssociationUsersBeacons < ActiveRecord::Migration
  def change
    create_table :beacons_users do |t|
      t.belongs_to :user
      t.belongs_to :beacon
    end
  end
end
