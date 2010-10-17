var youtube = function() { 
  var thumbnail_fetch = function (url, callback) {
    var query_string = url.split(/\?/)[1];
    var query_pairs = {};
    $.each(query_string.split(/&/), function (i, e) {
      var pair = e.split(/=/);
      query_pairs[pair[0]] = pair[1];
    });
    var vid_id = query_pairs['v'];
    $.ajax({
      url: 'http://gdata.youtube.com/feeds/api/videos/' + vid_id,
      dataType: 'json',
      data: {'alt':'json'},
      success: callback,
      error: function (xhr, status, err) {}
    });
  };

  var display_thumbnail = function (thumbnail, youtube_url) {
    console.log("displaying ", thumbnail);
    console.log("displaying ", youtube_url);
    thumbnail_fetch(youtube_url, function (data, textSuccess, xhr) {
      thumbnail.html("");
      // It appears as though the entry I'm looking for is always first in the
      // entry.link array that's returned, but this is to make sure that the
      // URL being grabbed by this function is always the right one.
      var url = ($.grep(data.entry.link, function (e, i) { return e.rel === 'alternate'; }))[0].href;
      
      thumbnail.append(
          $(document.createElement('a'))
          .attr({
            href: url,
            title: data.entry['media$group']['media$title']['$t'],
            target: "_blank"
          })
          .append(
            $(document.createElement('img'))
            .attr({
              width: 120,
              height: 90,
              src: data.entry['media$group']['media$thumbnail'][0].url,
              title: data.entry['media$group']['media$title']['$t']
            })
          )
        );
    });
  }; 

  var self = {};
  self.init = function() {
    var updatePreview = function(element) { try {
          if (!element.val()) return;
          url = element.val(); 
          var thumbnail = element.siblings(".youtube-thumbnail");
          display_thumbnail(thumbnail, url);
        } catch(e) {
          civic.error("Error showing YouTube preview.");
        }
    };

    $(".video-preview").each(function() { display_thumbnail($(this), $(this).attr("data-url")); });
    var updatePreviewWithDelay =  function() {var element = $(this); setTimeout(function() { updatePreview(element);}, 50);};
    // TODO: consider the value of the change event, since 
    // no one will probably type a youtube url
    //$(".youtube").change(updatePreview);
    $(".youtube").bind("change", updatePreviewWithDelay);
    $(".youtube").bind("paste",  updatePreviewWithDelay);
    $(".youtube").each(updatePreviewWithDelay);
  };
  return self;
}();
$(youtube.init);

