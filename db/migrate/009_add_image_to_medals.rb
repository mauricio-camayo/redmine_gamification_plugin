class AddImageToMedals < ActiveRecord::Migration
  def self.up
    add_column :gamification_medal_types, :image, :binary
  end

  def self.down
    remove_column :gamification_medal_types, :image
  end
end

