class CreatePosts < ActiveRecord::Migration

  def change
    create_table :posts do |t|
      t.integer :article_id, :default => nil
      t.string :headline, :limit => 255
      t.string :author, :limit => 255
      t.text :content
      t.string :article_url, :limit => 255
      t.string :media_provider, :limit => 255
      t.datetime :publish_date, :default => nil
      t.string :blog_post_sentiment, :limit => 255
      t.string :signal_tag_sentiment, :limit => 255
      t.priority :integer, :default => 0
    end
  end

end
