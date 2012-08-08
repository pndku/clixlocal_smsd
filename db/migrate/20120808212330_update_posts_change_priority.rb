class UpdatePostsChangePriority < ActiveRecord::Migration

  def change
    change_table :posts do |t|
      t.remove :priority
      t.references :postPriority
    end
  end

end
