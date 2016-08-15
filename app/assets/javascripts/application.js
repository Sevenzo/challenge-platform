// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require underscore
//= require bootstrap-sprockets
//= require angular
//= require angular-resource
//= require angular-sanitize
//= require angular-animate
//= require angular-scroll
//= require select2
//= require bootstrap-switch
//= require cocoon
//= require redactor-rails
//= require redactor-rails/plugins
//= require_tree .
//= require rails.validations
//

$(document).ready(function() {
  $('#facebook-login').click(function(event){

    // Triggers the validation check on #user_role field
    $input = $('#user_role');
    $form = $input.closest('form');
    $input.data('changed', true);

    // Only proceed to href if #user_role is valid
    var validUserRole = $input.isValid($form[0].ClientSideValidations.settings.validators);
    if ( !validUserRole ) {
      alert('No dice!')
      event.preventDefault(); // Prevent link from following its href
    }
  });
});
