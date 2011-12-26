$(document).ready(function(){

  $('.membership a.join').live('click', function(){
    var $membership_button = $(this)
    var join_url = $membership_button.attr('href');
    
    $.colorbox({href:"/user/confirm_membership"});
    
    $('a.confirm_membership').live('click', function(){
      $.post(join_url, function(data) {
        $membership_button.replaceWith(data);
        $.colorbox.close();
      });
      return false
    })
    
    $('a.cancel').live('click', function(){
        $.colorbox.close();
        return false
      });
    return false
    });
  
  $(".membership a.remove").live("ajax:success", function(e, data, status, xhr) {
      $(this).closest('.membership').replaceWith(data);
    });
});