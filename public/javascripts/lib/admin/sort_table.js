$(document).ready(function(){
  $('table.people').tablesorter();
  $('table.invites').tablesorter({
    widgets: ['zebra','repeatHeaders']
  });
});
