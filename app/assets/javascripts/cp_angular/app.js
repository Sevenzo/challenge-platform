app = angular.module("CPApp", ['ngSanitize', 'ngResource', 'ngAnimate', 'duScroll', 'ngFitText']);

app.value('duScrollDuration', 1000).value('duScrollOffset', 30);

$(document).on('turbolinks:load', function() {
  angular.bootstrap(document.body, ['CPApp']);
});
