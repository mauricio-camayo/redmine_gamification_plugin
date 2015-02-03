module GamificationUtil
  # Level check function
  def check_level(old, new)
    if old < new
      return new
    end
    old
  end

  # Calculation of the level
  def decide_level(point)
    lvl = 1
    total = point
    up_point = 100
    if Setting.plugin_redmine_gamification_plugin.has_key?('first_level_points')
      up_point = Setting.plugin_redmine_gamification_plugin['first_level_points'].to_i
    end
    multiplier = 1.2
    if Setting.plugin_redmine_gamification_plugin.has_key?('level_multiplier')
      multiplier = Setting.plugin_redmine_gamification_plugin['level_multiplier'].to_f
    end
    while total >= up_point
      lvl += 1
      total = total - up_point
      up_point = up_point * multiplier
    end
    lvl
  end

  def check_badge(user_badge, lvl)
    user_badge.lvl5_badge   = 1 if 5   <= lvl
    user_badge.lvl10_badge  = 1 if 10  <= lvl
    user_badge.lvl50_badge  = 1 if 50  <= lvl
    user_badge.lvl100_badge = 1 if 100 <= lvl
    user_badge
  end
end
