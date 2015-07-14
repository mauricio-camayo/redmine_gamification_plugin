# coding: utf-8

class Gamification < ActiveRecord::Base
  unloadable

  belongs_to :user
  has_one :gamification_medal_assignment, {foreign_key: 'user_id', primary_key: 'medal_id'}

  def up_point(add_point)
    self.point += add_point
  end

  def down_point(point)
    self.point -= point
  end

  def up_ticket_count
    self.ticket_count += 1
  end
end
