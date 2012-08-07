class UpdatePropertiesAddIndexName < ActiveRecord::Migration

  def change
    add_index :properties, :name, {:unique => true}
  end

end
