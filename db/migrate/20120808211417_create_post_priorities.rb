class CreatePostPriorities < ActiveRecord::Migration

  def change
    create_table :post_priorities do |t|
      t.string :name, :limit => 255
    end

    add_index :post_priorities, :name, {:unique => true}

    PostPriority.create!(:name => 'High')
    PostPriority.create!(:name => 'Medium')
    PostPriority.create!(:name => 'Low')
  end

end
