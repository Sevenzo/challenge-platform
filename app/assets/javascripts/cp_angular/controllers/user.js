app.controller('UserCtrl', function($scope, $animate) {

  $scope.otherLEA = function(arg){
    $scope.other_lea = arg;
    $scope.other_placeholder = 'Please type in your District or CMO';
    var $html_element = $('#user_district_ids').siblings('.select2-container');
    arg ? $html_element.hide() : $html_element.show();
  }

  $scope.otherSchool = function(arg){
    $scope.other_school = arg;
    $scope.other_placeholder = 'Please type in your school';
    var $html_element = $('#user_school_ids').siblings('.select2-container');
    arg ? $html_element.hide() : $html_element.show();
  }

});
