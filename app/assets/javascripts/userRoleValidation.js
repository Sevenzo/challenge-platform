$(document).ready(function() {
  $('#facebook-login').click(function(event){

    // Triggers the validation check on #user_role field
    $input = $('#user_role');
    $form = $input.closest('form');
    $input.data('changed', true);

    // Only proceed to href if #user_role is valid
    const validUserRole = $input.isValid($form[0].ClientSideValidations.settings.validators);
    if ( !validUserRole ) {
      // Prevent link from following its href
      event.preventDefault();
    } else {
      // Extract the user's selected Role and add it as a URI param to be sent to CallbacksCrontroller#facebook.
      const selectedRole = encodeURIComponent($('#user_role :selected').val());

      // Append the selected Role as a URI param.
      this.href += '?role=' + selectedRole;
    }
  });
});
