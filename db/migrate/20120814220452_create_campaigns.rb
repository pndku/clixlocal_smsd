class CreateCampaigns < ActiveRecord::Migration

  def change
    create_table :campaigns do |t|
      t.string :name, :limit => 255
      t.text :description
      t.text :keywords
    end
  end

end
