$(document).ready(function() {
	$('a.conversation-action').click(PopulateCommentActionDiv);
	$('a.conversation-action').href = "javascript:void();";
	$("#show_conversation #save_post").click(SavePost);
	$("#show_conversation #conversation_rating").hover(ShowRatingTools, HideRatingTools);
	InitializePostBox();
});

/*
	Populate a DIV with HTML to enter a comment/question/etc. at the indicated
	point in the conversation.
*/
function PopulateCommentActionDiv() {
	var action_link_id = this.id;
	var action_div_id = action_link_id.replace(/action-link/, 'action-div');
	var id = action_link_id.replace(/^action-link-/, '');
	var comment_input = $("#conversation_1_comment_input").html();
	var preview_input_id = "preview_post-" + id;
	var preview_input = '<a class="button tertiary" href="#" title="Save to the Stream" id="' + preview_input_id + '">Preview</a>'
	try {
		$("#" + action_div_id).html(comment_input + preview_input); // load the HTML
		$("#" + preview_input_id).click (function(){ClickSubmit(id)}); // set the Preview button (to do a Submit actually)
		$("#" + preview_input_id).each(function(){
			this.href = "javascript:void(0);"; // fix the URL of the Preview button to avoid page refresh
		})
	}
	catch (e) {
		alert("Error in setting up new comment div: " + e);
	}
}

/*
	Right now there is not really a Preview. It's the same as Submit.
*/
function ClickSubmit(id) {
	PostComment('Comment', id);
}

function SetupComment() {
	$("#post_content").attr("name", "comment[content]");
	//$("#post_content").attr("placeholder", "Leave a Comment...");	
	$("#post_model_type").val("Comment");	
	$("#preview_post").unbind();
	$("#preview_post").click(PreviewComment);
}

function TearDownComment() {
	$("#post_content").val("");
}

function SetupQuestion() {
	$("#post_content").attr("name", "question[content]");
	$("#post_content").attr("placeholder", "Ask a Question...");	
	$("#post_model_type").val("Question");
	$("#post_content").val("");	
	$("#preview_post").unbind();	
	$("#preview_post").click(PreviewQuestion);
}

function InitializePostBox() {
	SetupComment();
}

function PreviewComment() {
	PostComment('Conversation');
}

function PreviewQuestion() {
	PostQuestion();
}

function ShowRatingTools() {
	$("#show_conversation #conversation_rating a.toggle").show();
}

function HideRatingTools() {
	$("#show_conversation #conversation_rating a.toggle").hide();
}

function ShowError(xhr, status, error, memo) {
var string = "There was a " + status + " in " + memo + ".\n"
	if (error) {
		string += " The error text is " + error.toString() + ".\n"
	}
	if (xhr) {
		string += " Status: " + xhr.status + "\n";
		string += " See server log for details.\n";
	}
	alert(string);
}

function RateConversation(conversation_id, rating) {
	var data = "";
	data = data + "conversation_id=" + $("#conversation_id").val();
	data = data + "&rating="+rating;
	
	$.ajax({
		url: "/conversations/rate",
		type: "POST",
		data: data,
		success: function(response) {
			var rating = parseInt(response);
			if (rating == 0)
				$("#conversation_rating a.current_rating").html(response)
			else if (rating > 0)
				$("#conversation_rating a.current_rating").html("+"+response)
			else
				$("#conversation_rating a.current_rating").html("-"+response)			
			
		},
		error: function(xhr, status, error) {
		}
	})
}

function SavePost() {
	var postable_type = $("#postable_type").val();
	if (postable_type == "comment") {
		PostComment();
	} else if (postable_type == "question") {
		PostQuestion();
	}
}

/*
	Example:
		PostComment('Conversation', 10) ---> posts to Conversation #10
		PostComment('Comment', 48) ---> posts to Comment #48
*/

function PostComment(conversable_type, conversable_id) {
	var data = "";
	if (null == conversable_type)
	{
		conversable_type = 'Conversation'
	}
	if (null == conversable_id)
	{
		conversable_id = $("#conversation_id").val();
	}
	$("[name*=comment]:input").each(function(){
		data = data + $(this).attr("name") + "=" + escape($(this).val()) + "&";
	});
	data = data + conversable_type + "_id=" + escape(conversable_id) + "&";
	data = data + "post_model_type=" + escape($("#post_model_type").val());
	$.ajax({
		url: "/conversations/create_post",
		type: "POST",
		data: data,
		success: function(response) {
			try {
				alert ("Your comment posted, but you have to refresh the page to see it. Sorry.");
				$(response).hide().appendTo($("ul.thread-list")).slideDown("slow");
				TearDownComment();
				SetupComment();
			}
			catch (e) {
				alert ("Your comment posted, but something went wrong when redisplaying it in the thread: " + e);
			}
		},
		error: function(xhr, status, error) {
			ShowError(xhr, status, error, "posting your comment")
		}
	})
}

function PostQuestion() {
	var data = "";
	$("[name*=question]:input").each(function(){
		data = data + $(this).attr("name") + "=" + escape($(this).val()) + "&";
	});
	data = data + "conversation_id=" + escape($("#conversation_id").val()) + "&";	
	data = data + "post_model_type=" + escape($("#post_model_type").val());	
	$.ajax({
		url: "/conversations/create_post",
		type: "POST",
		data: data,
		success: function(response) {
			$(response).hide().appendTo($("ul.thread-list")).slideDown("slow");
			SetupQuestion();
		},
		error: function(xhr, status, error) {
			ShowError(xhr, status, error, "posting your question")
		}
	})
}
