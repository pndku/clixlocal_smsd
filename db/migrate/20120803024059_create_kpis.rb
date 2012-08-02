class CreateKpis < ActiveRecord::Migration

  def change
    create_table :kpis do |t|
      t.date :date, :default => nil
      t.integer :petition_signatures, :default => 0
      t.integer :petition_recommendations, :default => 0
      t.integer :tweets, :default => 0
      t.integer :facebook_discussions, :default => 0
      t.integer :negative_reviews_on_bhbhc_fb, :default => 0
      t.integer :negative_reviews_on_barnabas_health_fb, :default => 0
      t.integer :email_complaints, :default => 0
    end

    add_index :kpis, :date, {:unique => true}
  end

end
