app.factory("Initialize", function($scope) {
  return {
    show: function(hash, prefix, id, suffix) {
      // e.g. problem_statement-1 => problem_statement_1_ideas
      // then in `ideas_stages/show.html.erb`
      //   prefix = 'problem_statement'
      //   id = <%= problem_statement.id %>
      //   suffix = 'ideas'
      // And `prefixIdSuffix = 'problem_statement_1_ideas'`

      console.log('STEDMAN: args in:',$scope, hash, prefix, id, suffix)

      // On page load, we initialize $scope.prefixIdSuffix = false, unless that prefixIdSuffix is listed in the url hash.
      var prefixIdSuffix = [prefix,id,suffix].join('_');

      // Use the hash to generate the scope variable that we'd like to set to `true`.
      // For example, with `hash = '#theme-1'` => construct scope variable name `theme_1_experiences`
      console.log('STEDMAN: legit?',`_${suffix}`);
      var prefixIdSuffixToShow = (hash.split('#')[1]+`_${suffix}`).replace(/-/,'_');

      $scope[prefixIdSuffix] = prefixIdSuffix === prefixIdSuffixToShow;
    }
  }
});
