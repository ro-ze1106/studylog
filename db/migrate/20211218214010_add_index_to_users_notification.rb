class AddIndexToUsersNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :notification, :boolean, defult: false
  end
end
