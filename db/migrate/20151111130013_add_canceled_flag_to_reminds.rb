class AddCanceledFlagToReminds < ActiveRecord::Migration
  def change
    add_column :reminds, :canceled, :boolean
  end
end
