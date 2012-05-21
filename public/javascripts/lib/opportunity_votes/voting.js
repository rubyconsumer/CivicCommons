var reset_selected_option_positions = function(){
  $('input.selected_option').each(function(i){
    var index = i + 1
    $(this).attr('name', 'survey_response_presenter[selected_option_'+ index +'_id]');
    $(this).attr('id', 'survey_response_presenter_selected_option_'+ index +'_id');
  })
}
$(document).ready(function() {
  $('.opportunities-ol').sortable({
    update: reset_selected_option_positions
  });  
})

