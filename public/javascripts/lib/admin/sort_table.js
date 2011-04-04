$(document).ready(function(){
  $('table.people').tablesorter();
  $('table.conversations').tablesorter({
    headers: { 0: { sorter: false}, 4: { sorter: false} }
  });
});
