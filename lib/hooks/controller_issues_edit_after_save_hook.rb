require 'gamification_util.rb'

module Hooks
  class ControllerIssuesEditAfterSaveHook < Redmine::Hook::ViewListener

    include GamificationUtil

    def controller_issues_edit_after_save(context={})
      # will use gamification for edit issues?
      if Setting.plugin_redmine_gamification_plugin.has_key?("use_edit_issue")
        if context[:params] && context[:params][:issue]
          if User.current.allowed_to?(:assign_deliverable_to_issue, context[:issue].project)
            if context[:params][:issue][:deliverable_id].present?
              deliverable = Deliverable.find_by_id(context[:params][:issue][:deliverable_id])
              if deliverable.contract.project == context[:issue].project
                context[:issue].deliverable = deliverable
              end

            else
              context[:issue].deliverable = nil
            end
          end
          current_user_id = User.current.id
          project_id = Issue.find(context[:params][:id]).project_id
          
          # gamification_user_update
          if Gamification.exists?({user_id: current_user_id})
            user = Gamification.find_by_user_id(current_user_id)
#            user_badge = GamificationBadge.find_by_user_id(current_user_id)

            if(Setting.plugin_redmine_gamification_plugin.has_key?("edit_issue_score"))
              user.up_point(Setting.plugin_redmine_gamification_plugin['edit_issue_score'].to_i)
            end
              
            if(Setting.plugin_redmine_gamification_plugin.has_key?("closing_points"))
              status = IssueStatus.find_by_id(context[:issue][:status_id])
              if(status[:is_closed])
                user.up_point(Setting.plugin_redmine_gamification_plugin['closing_points'].to_i)
              end
            end
            # check level
            old_lvl = user.level
            new_lvl = decide_level(user.point)
            user.level = check_level(old_lvl, new_lvl)
            user.save

#            # update user badge
#            new_badge = check_badge(user_badge, user.level)
#            new_badge.save
          end

          # gamification_project_update
          if GamificationProject.exists?({user_id: current_user_id, project_id: project_id})
            user_project = GamificationProject.find_by_user_id_and_project_id(current_user_id, project_id)
            user_project.up_point(Setting.plugin_redmine_gamification_plugin['edit_issue_project_score'].to_i) 
            user_project.up_ticket_count
            user_project.save
          end
        end
      end
      return ''
    end
  end
end
