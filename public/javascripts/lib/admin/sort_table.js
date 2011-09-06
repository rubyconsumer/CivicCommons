$(document).ready(function(){
  if($('table.people').tablesorter!=undefined) {
    $('table.people').tablesorter();
    $('table.conversations').tablesorter({
      headers: { 0: { sorter: false}, 4: { sorter: false} }
    });
  }
});
