class RemovePostPriorities < ActiveRecord::Migration

  def change
    drop_table :post_priorities
  end

end
