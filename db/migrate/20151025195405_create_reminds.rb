class CreateReminds < ActiveRecord::Migration
  def change
    create_table :reminds do |t|
      t.string :content, limit: 1024
      t.timestamp :date_start
      t.timestamp :date_end
      t.string :recurrence, limit: 1
      t.timestamps null: false

      t.belongs_to :user
      t.belongs_to :beacon
    end
  end
end
