$(document).ready(function() {
	$("#show_conversation #save_post").click(SavePost);
	$("#show_conversation #conversation_rating").hover(ShowRatingTools, HideRatingTools);
	InitializePostBox();
});

function SetupComment() {
	$("#post_content").attr("name", "comment[content]");
	$("#post_content").attr("placeholder", "Leave a Comment...");	
	$("#preview_post").click(PreviewComment);
}

function SetupQuestion() {
	$("#post_content").attr("name", "question[content]");
	$("#post_content").attr("placeholder", "Ask a Question...");	
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
	$.ajax({
		url: "/conversations/"+$("#conversation_id").val()+"/create_post",
		type: "POST",
		data: data,
		success: function(response) {
			$(response).hide().appendTo($("ul.thread-list")).slideDown("slow");
			SetupComment();
		},
		error: function(xhr, status, error) {
			alert(error + " " + status);
		}
	})
}

function PostQuestion() {
	var data = "";
	$("[name*=question]:input").each(function(){
		data = data + $(this).attr("name") + "=" + escape($(this).val()) + "&";
	});
	$.ajax({
		url: "/conversations/"+$("#conversation_id").val()+"/create_post",
		type: "POST",
		data: data,
		success: function(response) {
			$(response).hide().prependTo($("ul.thread-list")).slideDown("slow");
			SetupQuestion();
		},
		error: function(xhr, status, error) {
			alert(error + " " + status);
		}
	})
}