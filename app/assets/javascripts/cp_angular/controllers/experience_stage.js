app.controller('ExperienceStageCtrl', function($scope, $document, $timeout) {
  var hash = window.location.hash;
  $scope.show_all = hash != '';

  // For the front end, update the view and scroll to the right element
  $timeout(function(){
    if ($scope.show_all) {
      // Use the hash to generate the scope variable that we'd like to set to `true.
      // Starting with `hash`, of the form `#theme-1` => construct scope variable name `theme_1_experiences`
      var themeIdExperiences = (hash.split('#')[1]+'_exJHperiences').replace(/-/,'_');

      $scope[themeIdExperiences] = true;
      console.log('========================', themeIdExperiences, $scope[themeIdExperiences]);

      var target = angular.element(document.getElementById(hash.substring(1)));
      $document.scrollToElement(target, 60, 2000);
    }
  });
});
