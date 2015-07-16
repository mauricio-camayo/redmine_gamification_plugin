class GamificationMedalType < ActiveRecord::Base
  unloadable

  belongs_to :gamification_medal_type, foreign_key: 'medal_id'
end
