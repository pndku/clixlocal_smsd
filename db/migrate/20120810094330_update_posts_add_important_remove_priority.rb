class UpdatePostsAddImportantRemovePriority < ActiveRecord::Migration

  def change
    change_table :posts do |t|
      t.remove :postPriority_id
      t.boolean :important, :default => false, :null => false
    end
  end

end
