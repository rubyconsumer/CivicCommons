$(document).ready(function() {
	$("#save_post").click(SavePost);
});

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