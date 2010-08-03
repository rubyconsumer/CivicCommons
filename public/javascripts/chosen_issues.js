/*
 chosen_issues.js
 FIXME: Sanitize all the inputs.
 FIXME: Check error conditions.
 FIXME: Adapt for Spotlights and Guides too.
 FIXME: Degradation.
 FIXME: Fixed URLs.
*/

/*
  Class wraps around array, used to support in-script list of
  selected items such as Issues, Spotlights, or Guides.
*/

var chosen_issues = new SelectionList()
var chosen_guides = new SelectionList()
var chosen_spotlights = new SelectionList()

function SelectionList()
{
  this.data = []
  this.remove = function(x)
  {
    var tmp = $.inArray(this.data,x)
    if (tmp >= 0)
    {
      this.data.splice(tmp,tmp)
      return true
    }
    return false
  }
  this.add = function(x)
  {
    if ($.inArray(this.data,x) < 0)
    {
      this.data.push(x)
      return true
    }
    return false
  }
  this.values = function()
  {
    return this.data
  }
}

/*
 Redisplay the chosen items with links to detail and links
 to remove chosen items.
*/
function refresh_chosen_issues(div)
{
var output = "";
  try
  {
  output += "<ul>\n"
    for (var i = 0; i < chosen_issues.data.length; i++)
    {
var issue_detail = "";
var description;
      x = chosen_issues.data[i]
      $.ajax({
       url: "http://localhost:3000/issues/" + x + ".json",
       success: function(data) { issue_detail = data; },
       failure: function(data) { alert("couldn't pick up details for issue #" + x + "!"); },
       async: false,
       })
      description = issue_detail.issue.description
      output += "<li>\n"
var id = issue_detail.issue.id
      output += '<a href="/issues/' + id + ' title="' + description + '">' + description + "</a>\n"
      output += '<input name="issue_ids[]" id="issue_'+id+'" type="hidden" value="'+id+'" />\n'
      output += '<a href="javascript:void()" onclick="drop_issue(' + id + ')" title="' + description + '"><img src="/images/trash-can.png" alt=" [remove issue] "></a>' + "\n"
      output += "</li>\n"
    }
    output += "</ul>\n"
    div.html(output)
  }
  catch (e)
  {
    alert ("Exception in refresh_chosen_issue: " + e)
  }
}

/*
 Hide the "Confirm Add" link and show the "Add an Issue" link.
*/
function cancel_add_issue()
{
var link = $("#addissueprompt")
  link.fadeIn();
  $("#addissue").fadeOut();
}

/*
 Cut an issue from the chosen issues list and refresh it.
*/
function drop_issue(n)
{
  chosen_issues.remove(n)
  refresh_chosen_issues($("#chosenissues"))
var link = $("#addissueprompt")
  link.fadeIn()
  $("#addissue").fadeOut()
  refresh_issues_select($("#newissue"))
}

/*
 Add an issue to the chosen issues list and refresh it.
*/
function add_and_refresh(sel)
{
  try
  {
	
var n = sel.val()
var div = $("#chosenissues")
    chosen_issues.add(n)
    refresh_chosen_issues(div)
  var link = $("#addissueprompt")
    link.fadeIn();
    $("#addissue").fadeOut();
    refresh_issues_select($("#newissue"))
  }
  catch (ex)
  {
    alert("Exception in add/refresh: " + ex);
  }
}

function refresh_issues_select(el)
{
var output = "";

/* FIXME: catch success and failure here */
var all_issues = []
$.ajax({
 url: "http://localhost:3000/issues.json",
 success: function(data) { all_issues = data; },
 async: false,
 })
  for (var i = 0; i < all_issues.length; i++)
  {	
    var x = all_issues[i].issue
    if ($.inArray(x.id.toString(),chosen_issues.data) == -1)
    {
      output += "<option value=" + x.id + ">" + x.description + "</option>\n"
    }
  }
  el.html(output)
}
