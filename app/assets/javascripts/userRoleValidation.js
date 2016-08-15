$(document).ready(function() {
  $('#facebook-login').click(function(event){

    // Triggers the validation check on #user_role field
    $input = $('#user_role');
    $form = $input.closest('form');
    $input.data('changed', true);

    // Only proceed to href if #user_role is valid
    var validUserRole = $input.isValid($form[0].ClientSideValidations.settings.validators);
    if ( !validUserRole ) {
      // alert('Please select your Role!')
      event.preventDefault(); // Prevent link from following its href
    }
  });
});
