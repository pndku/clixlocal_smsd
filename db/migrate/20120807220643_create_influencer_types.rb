class CreateInfluencerTypes < ActiveRecord::Migration

  def change
    create_table :influencer_types do |t|
      t.string :name, :limit => 255
    end

    add_index :influencer_types, :name, {:unique => true}

    InfluencerType.create!(:name => 'Group')
    InfluencerType.create!(:name => 'Individual')
  end

end
