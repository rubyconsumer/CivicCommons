$(document).ready(function() {

  $('.notification-container .dropdown-toggle').click(function(){

    $.ajax({
      type: "post",
      url: "/notifications/viewed",
      success: function() {
        $('.notification-info').html("0");
        $('.notification-main').addClass('notification-inactive')
        $('.notification-main').removeClass('notification-active')

      }
    });

  });

});
