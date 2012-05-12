// alert('here');
var reset_option_positions = function(){
  $('.option-position').each(function(i){
    $(this).val(i+1);
  })
};

var delete_option = function(el){
  if (confirm('Are you sure you want to delete this?')){
    $(el).closest('.survey-option').hide('fast', function(){
      $(this).remove();
    });
  }
  return false;
}