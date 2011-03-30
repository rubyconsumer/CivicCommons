$(document).ready(function(){
  $('table.people').tablesorter();
  $('table.conversations').tablesorter({
    headers: { 0: { sorter: false}, 5: { sorter: false} }
  });
});
