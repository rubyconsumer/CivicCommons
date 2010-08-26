(function($){
  $.fn.customTabs = function(){
    return this.each(function(){
      var $self = $(this);

      $links = $self.find("a");

      $self.find("a.tab-active");

      $(".tab-area>div").hide();

      $links.each(function(){
        $(this).click(function(){
          $(".tab-area>div").hide();
          var id = $(this).attr("href");
          $self.find("a").removeClass("tab-active");
          $(this).addClass("tab-active");
          $(id).show();
          return false;
        });
      });

      $firstLink = $($links[0]);
      $($firstLink.attr("href")).show();
      $firstLink.addClass("tab-active")
    });
  }
})(jQuery)
