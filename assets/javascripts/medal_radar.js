window.onload = function() {
  var rc = new html5jp.graph.radar('sample');
  if (!rc) { return; }
  var items = [
    ['Medals Earned', <%= @user.gamification_medal.thank_medal  %>,
                   <%= @user.gamification_medal.smile_medal  %>,
                   <%= @user.gamification_medal.hot_medal  %>,
                   <%= @user.gamification_medal.nice_medal  %>,
                   <%= @user.gamification_medal.comm_medal  %>,
                   <%= @user.gamification_medal.grow_medal  %>]
  ];
  var params = {
    aCap: ['Thanks Medal', 'Smile Medal', 'Blooded Medal',
           'Nice Medal', 'Communication Medal', 'Growth Medal']
  };
  rc.draw(items, params);
}
