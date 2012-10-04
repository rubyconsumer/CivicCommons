$(document).ready(function() {
  $(".js-accordion dt").click(function() {
    $(this).next(".js-accordion dd").slideToggle("fast");
  });
  return false;
});
