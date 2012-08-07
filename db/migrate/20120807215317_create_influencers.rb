class CreateInfluencers < ActiveRecord::Migration

  def change
    create_table :influencers do |t|
      t.references :influencerType
      t.string :name, :limit => 255
      t.string :url, :limit => 255
      t.integer :followers, :default => 0
    end

    add_index :influencers, :name, {:unique => true}
  end

end
