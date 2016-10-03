$(function () {
  $('[data-toggle=tooltip]').tooltip({container: 'body'});
  $('[data-toggle="popover"]').popover({html: true});
  $('.radio-switch').bootstrapSwitch();
});

_.templateSettings = {
  evaluate    : /\<\{([\s\S]+?)\}\>/g,
  interpolate : /\<\{=([\s\S]+?)\}\>/g,
  escape      : /\<\{-([\s\S]+?)\}\>/g
};
