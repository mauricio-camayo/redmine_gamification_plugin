class GamificationMedalAssignment < ActiveRecord::Base
  unloadable

  belongs_to :gamification_medal, foreign_key: 'medal_id'
end
