$(document).ready(function() {
        $('a.conversation-action').click(CommentAction);
	$("#show_conversation #save_post").click(SavePost);
	$("#show_conversation #conversation_rating").hover(ShowRatingTools, HideRatingTools);
	InitializePostBox();
});

function CommentAction() {
	//alert("I am action-link!\n" + this.id);
	var action_link_id = this.id;
	var action_div_id = action_link_id.replace(/action-link/, 'action-div');
	var id = action_link_id.replace(/^action-link-/, '');
	//alert("My action div is " + action_div_id + "!");
	var comment_input = $("#conversation_1_comment_input").html();
	var preview_input_id = "preview_post-" + id;
	var preview_input = '<a class="button tertiary" href="#" title="Save to the Stream" id="' + preview_input_id + '">Preview</a>'
	$("#" + action_div_id).html(comment_input + preview_input);
	$("#" + preview_input_id).click(function(){ClickSubmit(id)});
	/*
	var preview_button = new Element("a");
	preview_button.className = "button tertiary"
	preview_button.href = "#"
	preview_button.title = "Save to the Stream"
	preview_button.id = "preview_post-" + id
	//preview_button.onClick...
	$("#" + action_div_id).append(preview_button);
	*/
}

function ClickSubmit(id) {
	alert(id);
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
	PostComment();
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

function PostComment() {
	var data = "";
	$("[name*=comment]:input").each(function(){
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
			TearDownComment();
			SetupComment();
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
