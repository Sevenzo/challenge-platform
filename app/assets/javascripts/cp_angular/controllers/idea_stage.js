app.controller('IdeaStageCtrl', function($scope, $document, $timeout) {
  var hash = window.location.hash;
  $scope.show_all = hash != '';

  // On page load, we initialize problem_statement_:id_ideas=false, unless that theme is listed in the url hash.
  $scope.initialize = function(prefixIdSuffix) {
    // Use the hash to generate the scope variable that we'd like to set to `true`.
    // For example, with `hash`, of the form `#problem_statement-1` => construct scope variable name `problem_statement_1_ideas`
    var prefixIdSuffixToShow = (hash.split('#')[1]+'_ideas').replace(/-/,'_');

    $scope[prefixIdSuffix] = prefixIdSuffix === prefixIdSuffixToShow;
  };

  // For the front end, update the view and scroll to the right element
  $timeout(function(){
    if ($scope.show_all) {
      var target = angular.element(document.getElementById(hash.substring(1)));
      $document.scrollToElement(target, 150, 2000);
    }
  });
});
