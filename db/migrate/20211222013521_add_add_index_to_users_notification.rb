class AddAddIndexToUsersNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :notification, :boolean, default: false
  end
end
