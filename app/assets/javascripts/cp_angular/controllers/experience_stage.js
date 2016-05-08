app.controller('ExperienceStageCtrl', ['Initialize', function($scope, $document, $timeout, Initialize) {
  var hash = window.location.hash;
  $scope.show_all = hash != '';

  // On page load, we initialize theme_:id_experiences=false, unless that theme is listed in the url hash.
  $scope.initialize = function(prefix, id, suffix) {
    console.log('Initial $scope (should be undefined)', $scope[[prefix, id, suffix].join('_')]);

    var hash = window.location.hash;

    console.log(hash, prefix, id, suffix);

    Initialize.show(hash, prefix, id, suffix);
    console.log('Updated $scope', $scope[[prefix, id, suffix].join('_')]);
  }

  // Initialize.show()
  //   // Use the hash to generate the scope variable that we'd like to set to `true`.
  //   // For example, with `hash`, of the form `#theme-1` => construct scope variable name `theme_1_experiences`
  //   var themeIdExperienceToShow = (hash.split('#')[1]+'_experiences').replace(/-/,'_');

  //   $scope[themeIdExperiences] = themeIdExperiences === themeIdExperienceToShow;
  // };

  // For the front end, update the view and scroll to the right element
  $timeout(function(){
    if ($scope.show_all) {
      var target = angular.element(document.getElementById(hash.substring(1)));
      $document.scrollToElement(target, 60, 2000);
    }
  });
}]);
