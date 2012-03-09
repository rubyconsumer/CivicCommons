// jquery.tinymce plugin
(function( $ ) {
  var methods = {
    // return the tinymce instance associated with this element
    init : function () {
      return this.data('tinymce');
    },

    remove : function() {
      this.removeClass('tinymce-loaded tinymce-uninitialized');
      return this.data('tinymce').remove();
    },

    setContent : function(content) {
      return this.data('tinymce').setContent(content);
    }
  };

  $.fn.tinymce = function(method) {
    // Method calling logic
    if ( methods[method] ) {
      return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'The method `' +  method + '` does not exist on jQuery.tinymce' );
    }
  };
})( jQuery );