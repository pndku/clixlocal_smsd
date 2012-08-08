class UpdateAdminUsersAddFields < ActiveRecord::Migration

  def change
    change_table :admin_users do |t|
      t.string :first_name, :limit => 255
      t.string :last_name, :limit => 255
      t.string :department, :limit => 255
    end
  end

end
