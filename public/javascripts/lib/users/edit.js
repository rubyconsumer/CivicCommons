    $(document).ready(function(){
      $('#delete').bind('ajax:success', function(event, data) {
        $(this).hide();
        var parsedData = $.parseJSON(data);
        $('a#profileImage img').attr('src', parsedData.avatarUrl);
      });
    });
