require_relative "./gamification_util.rb"
include GamificationUtil

module IssuePatch

  def self.included(base)
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable

      after_save :gamification_ticket_update

    end
  end

  module ClassMethods
  end

  module InstanceMethods
    
    def gamification_ticket_update
      current_user_id = User.current.id
      if Gamification.exists?({user_id: current_user_id})
        user = Gamification.find_by_user_id(current_user_id)

        # Status updates of user
        GamificationUtil::up_point(user, 10)
        user.up_ticket_count
        user.save
      end
    end

  end
end
