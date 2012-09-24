// Return a helper with preserved width of cells
var fixTableRowHelper = function(e, ui) {
  ui.children().each(function() {
    $(this).width($(this).width());
  });
  return ui;
};
var lastUpdatedRow = null;
var is_ascending = false;

function header_clicked(event){
  if($(this).hasClass('staff_pick_header')){
    $("table.conversations tbody").sortable("enable");
  } else {
    $("table.conversations tbody").sortable("disable");
  }
}

function update_sort(event, ui){
  lastUpdatedRow = $(ui.item);
  var current_index = $(ui.item).find('td.staff_pick_column span').html();
  var next_index = $(ui.item).next().find('td.staff_pick_column span').html();
  var prev_index = $(ui.item).prev().find('td.staff_pick_column span').html();
  var data = { current: current_index, next: next_index, prev: prev_index };

  if(next_index > prev_index){ is_ascending = true; }
  if(next_index < prev_index){ is_ascending = false; }

  $.post('/admin/conversations/update_order', data, function(data) {
    lastUpdatedRow.children().effect('highlight');
    $("table.conversations tbody td.staff_pick_column span").each(function(index, element){
      if(is_ascending)
      {
        $(this).html(index);
      }else{
        var rows = $("table.conversations tbody tr").length;
        $(this).html(rows - index - 1);
      }
    });
    $("table.conversations tbody td.staff_pick_column span").each(function(index, element){
      if(is_ascending)
      {
        $(this).html(index);
      }else{
        var rows = $("table.conversations tbody tr").length;
        $(this).html(rows - index - 1);
      }
    });
    $("table.conversations").trigger("update");
  });
}

$(document).ready(function(){
  $("table.conversations tbody").sortable({
    axis: "y",
    cancel: ".ui-state-disabled",
    containment: "table.conversations tbody",
    cursor: "move",
    disabled: true,
    handle: ".handle",
    helper: fixTableRowHelper,
    items: "tr:not(.ui-state-disabled)",
    update: update_sort
  });
  $("table.conversations tbody .handle").disableSelection();
  $("table.conversations thead th").click(header_clicked);
});
