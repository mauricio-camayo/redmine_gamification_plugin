require 'gamification_util.rb'

module Hooks
  class ControllerIssuesEditBeforeSaveHook < Redmine::Hook::ViewListener

    include GamificationUtil

    def controller_issues_edit_before_save(context={})
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
          
          original_issue = Issue.find(context[:params][:id])
          project_id = original_issue.project_id
          status_orig = IssueStatus.find_by_id(context[:params][:issue][:status_id])
          status_mod = IssueStatus.find_by_id(original_issue.status_id)
          
          points = 0
          
          if (status_orig.position < status_mod.position)
            if (Setting.plugin_redmine_gamification_plugin.has_key?('rem_score_status_'+status_mod.name))
              points += Setting.plugin_redmine_gamification_plugin['rem_score_status_'+status_mod.name].to_i
            end
          else if (status_orig.position > status_mod.position)
              if (Setting.plugin_redmine_gamification_plugin.has_key?('add_score_status_'+status_orig.name))
                points += Setting.plugin_redmine_gamification_plugin['add_score_status_'+status_orig.name].to_i
              end
            end
          end
          
          if (Setting.plugin_redmine_gamification_plugin.has_key?('assignee_to_current'))
            user_id = original_issue.assigned_to_id
          else
            user_id = context[:params][:issue][:assigned_to_id]
          end
          
          if(original_issue.tracker_id != context[:params][:issue][:tracker_id].to_i)  
            tracker = Tracker.find_by_id(context[:params][:issue][:tracker_id])
            if (Setting.plugin_redmine_gamification_plugin.has_key?('add_score_tracker_'+ tracker.name))
              points += Setting.plugin_redmine_gamification_plugin['add_score_tracker_'+ tracker.name].to_i
            end
          end
          
            
          # Assigning points for the assignee
          if Gamification.exists?({user_id: user_id})
            user = Gamification.find_by_user_id(user_id)
            user.up_point(points)
            user.save
          end
          
          # gamification_project_update
          if GamificationProject.exists?({user_id: user_id, project_id: project_id})
            user_project = GamificationProject.find_by_user_id_and_project_id(user_id, project_id)
            user_project.up_point(points) 
            user_project.save
          end
        end
      end
      return ''
    end
  end
end
