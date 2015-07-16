class GamificationMedalAssignment < ActiveRecord::Base
  unloadable
  
  before_create :set_date_added

  protected

  def set_date_added
    self.assign_date = Time.now
  end

  belongs_to :gamification, foreign_key: 'user_id'
  belongs_to :user, foreign_key: 'user_orig_id'
  has_one :gamification_medal_type, foreign_key: 'id', primary_key: 'medal_id'
end
