class UpdatePostsChangeArticleId < ActiveRecord::Migration

  def change
    change_table :posts do |t|
      t.change :article_id, :string, :limit => 255
    end
  end

end
