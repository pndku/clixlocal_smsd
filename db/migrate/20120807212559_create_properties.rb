class CreateProperties < ActiveRecord::Migration

  def change
    create_table :properties do |t|
      t.string :name, :limit => 255
      t.string :url, :limit => 255
      t.integer :followers, :default => 0
      t.integer :updates, :default => 0
      t.integer :engagements, :default => 0
    end
  end

end
