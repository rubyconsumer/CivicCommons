$(document).ready(function() {
	$("#show_conversation #save_post").click(SavePost);
	$("#show_conversation #conversation_rating").hover(ShowRatingTools, HideRatingTools);
});

function ShowRatingTools() {
	$("#show_conversation #conversation_rating a.toggle").show();
}

function HideRatingTools() {
	$("#show_conversation #conversation_rating a.toggle").hide();
}

function RateConversation(conversation_id, rating) {
	var data = "";
	data = data + "conversation_id=" + $("#conversation_id").val();
	data = data + "&rating[rating]="+rating;
	
	$.ajax({
		url: "/post_ratings",
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
	data = data + "conversation_id=" + $("#conversation_id").val();
	$.ajax({
		url: "/post_comments",
		type: "POST",
		data: data,
		success: function(response) {
			$(response).hide().prependTo($("ul.thread-list")).slideDown("slow");
			$("#comment_content").val("");
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
	data = data + "conversation_id=" + $("#conversation_id").val();
	$.ajax({
		url: "/post_questions",
		type: "POST",
		data: data,
		success: function(response) {
			$(response).hide().prependTo($("ul.thread-list")).slideDown("slow");
			$("#question_content").val("");
		},
		error: function(xhr, status, error) {
			alert(error + " " + status);
		}
	})
}