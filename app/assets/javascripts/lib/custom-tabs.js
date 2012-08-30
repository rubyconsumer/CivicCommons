(function($){
  $.fn.customTabs = function(){
    return this.each(function(){
      var $self = $(this);

      $self.next(".tab-area").children("div").hide();

      $links = $self.find("a");

      $firstLink = $links.eq(0);
      $($firstLink.attr("href")).show();
      $firstLink.addClass("tab-active");


      $links.each(function(){
        $(this).click(function(){

          var oldId = $self.find("a.tab-active").removeClass("tab-active").attr("href");
          $(oldId).hide();

          var newId = $(this).addClass("tab-active").attr("href");
          $(newId).show();

          return false;
        });
      });

    });
  }
})(jQuery);

