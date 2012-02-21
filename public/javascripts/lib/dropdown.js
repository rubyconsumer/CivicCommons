$(document).ready(function() {
  $('.dropdown-toggle').click(function (e) {
    $(this).next('.dropdown-menu').slideToggle('fast');
    e.preventDefault();
  });
});