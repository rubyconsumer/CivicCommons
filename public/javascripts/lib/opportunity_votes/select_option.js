var showRankOptionTab = function(){
  $('.rank-options-tab').fadeIn('slow');
  $('input.continue.opportunity-button').val('Continue');
}
var hideRankOptionTab = function(){
  $('.rank-options-tab').fadeOut('slow');
  $('input.continue.opportunity-button').val('Cast my Vote');
}
var selectOptionCheckBoxBehavior = function(){
  var $checked_boxes = $('input.option-checkbox:checked');
  var checked_count = $checked_boxes.length;
  if(checked_count < 1 || checked_count > 1){
    // console.log('show the tab');
    showRankOptionTab();
  }else{
    // console.log('hide the tab');
    hideRankOptionTab();
  };
}

$(document).ready(function() {
  //initialize with the checkbox behavior
  selectOptionCheckBoxBehavior();
  
  $('input.option-checkbox').change(function(){
    selectOptionCheckBoxBehavior()
  })
  
})

