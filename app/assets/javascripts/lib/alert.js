$(document).ready(function() {
  $('.dismiss').click(function (e) {
    $(this).parent('.alert').remove();
    e.preventDefault();
  });
});
