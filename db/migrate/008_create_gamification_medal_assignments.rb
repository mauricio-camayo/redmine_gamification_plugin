class CreateGamificationMedalAssignments < ActiveRecord::Migration
  def up
#    create_table :gamification_medal_types do |t|
#      t.integer :id
#      t.string :name
#    end
    
    create_table :gamification_medal_assignments do |t|
      t.integer :user_orig_id
      t.integer :user_assign_id
      t.integer :medal_id
      t.datetime :assign_date, :null => false, :default => Time.now
    end
    
    add_column :gamification_medals, :medal_id, :integer
    
    GamificationMedalType.create :name => ""
  end
  
  def down
    drop_table :gamification_medal_assignments
#    drop_table :gamification_medal_types
    remove_column :gamification_medals, :medal_id
    
  end
end