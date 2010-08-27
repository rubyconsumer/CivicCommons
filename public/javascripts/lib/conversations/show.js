$(document).ready(function() {
	$("#show_conversation #save_post").click(SavePost);
	$("#show_conversation #conversation_rating").hover(ShowRatingTools, HideRatingTools);
	InitializePostBox();
});

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
