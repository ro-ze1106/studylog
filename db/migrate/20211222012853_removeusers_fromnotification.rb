class RemoveusersFromnotification < ActiveRecord::Migration[6.1]
  def up
    remove_column :users, :notification
  end

  def down
    add_column :users, :notification, :boolean
  end
  
end
