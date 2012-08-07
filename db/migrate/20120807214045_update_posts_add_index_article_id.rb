class UpdatePostsAddIndexArticleId < ActiveRecord::Migration

  def change
    add_index :posts, :article_id, {:unique => true}
  end

end
