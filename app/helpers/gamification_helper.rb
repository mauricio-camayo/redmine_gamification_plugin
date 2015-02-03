module GamificationHelper
  def badge_image(name, flag)
    if flag == 0
      image_tag('/badges/hatena.jpg', {width: 200, height: 200, plugin: 'redmine_gamification_plugin'})
    elsif flag == 1
      name = '/badges/' + name
      p name
      image_tag(name, {width: 200, height: 200, plugin: 'redmine_gamification_plugin'})
    end
  end

end
