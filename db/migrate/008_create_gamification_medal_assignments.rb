class CreateGamificationMedalAssignments < ActiveRecord::Migration
  def up
    create_table :gamification_medal_types do |t|
#      t.integer :type_id, index:true
      t.string :name
    end
    
    create_table :gamification_medal_assignments do |t|
      t.integer :medal_id, index:true
      t.integer :user_orig_id
      t.integer :user_assign_id, index:true
      t.datetime :assign_date, :null => false
    end
    
    GamificationMedalType.create :name => "Thanks"
    GamificationMedalType.create :name => "Smile"
    GamificationMedalType.create :name => "Nice Job"
    GamificationMedalType.create :name => "Passion"
  end
  
  def down
    drop_table :gamification_medal_assignments
    drop_table :gamification_medal_types
    
  end
end