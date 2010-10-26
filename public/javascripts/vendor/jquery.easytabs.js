/*
 * jQuery EasyTabs plugin 1.1
 *
 * Copyright (c) 2010 Steve Schwartz (JangoSteve)
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * Date: Thu Aug 24 01:02:00 2010 -0500
 */
(function($) {
  
  $.fn.easyTabs.defaults = {
    animate: true, 
    panelActiveClass: "active", 
    tabActiveClass: "active", 
    defaultTab: "li:first-child", 
    animationSpeed: "normal", 
    tabs: "> ul > li", 
    updateHash: true, 
    cycle: false
  }
  
  var
  data,
  opts,
  clicked,
  targetDiv,
  $container,
  $tabs,
  $panels
  
  $.fn.easyTabs.methods = {
    init: function(options){
      $tabs = container.find(opts.tabs);
      $panels = $();

      $tabs.each(function(){
        targetId = this.children("a").attr("href").substr(1);
        $matchingPanel = container.find("div[id=" + targetId + "]");
        if ( $matchingPanel.size() > 0 ) {
          $panels = $panels.add($matchingPanel).hide());
        } else {
          $tabs = $tabs.not(this); // excludes tabs from set that don't have a target div
        }
      });
      $('a.anchor').remove().prependTo('body');
      
      $container.data("easytabs", {
        tabs: tabs,
        panels: panels,
        opts: opts,
        skipHashUpdateOnce: false
      });
      
      var defaultTab = methods.selectDefaultTab.apply(container);
          defaultTabLink = defaultTab.children("a").first();
          
      $(panels.filter("#" + defaultTabLink.attr("href").substr(1))).show().addClass(opts.panelActiveClass);

      defaultTab.addClass(opts.tabActiveClass).children().addClass(opts.tabActiveClass);

      tabs.children("a").bind("click.easytabs", function() {
        container.data("easytabs").opts.cycle = false;
        var clicked = $(this);
        if(clicked.hasClass(opts.tabActiveClass)){ return false; }
        methods.selectTabWithHashChange.apply(clicked,[container,tabs,panels]);
        return false;
      });
    },
    selectDefaultTab: function(){
      var container = this;
          data = container.data("easytabs");
          tabs = data.tabs;
          selectedTab = tabs.find("a[href='" + window.location.hash + "']").parent();
      if(selectedTab.size() == 1){
        defaultTab = selectedTab;
        opts.cycle = false;
      }else{
        defaultTab = $(tabs.parent().find(opts.defaultTab));
      }
      container.data("easytabs").defaultTab = defaultTab
      return defaultTab;
    },
    selectTab: function(container,tabs,panels,callback){
      var clicked = this;
          targetDiv = clicked.attr("href");
      
      if( ! clicked.hasClass(opts.tabActiveClass) ){
        container.trigger("easytabs:beforeChange");
        if(opts.animate){
          panels.filter("." + opts.panelActiveClass).removeClass(opts.panelActiveClass).fadeOut(opts.animationSpeed, function(){
            panels.filter(targetDiv).fadeIn(opts.animationSpeed, function(){ $(this).addClass(opts.panelActiveClass); container.trigger("easytabs:afterChange"); });
          });
        }else{
          panels.filter("." + opts.panelActiveClass).removeClass(opts.panelActiveClass).hide();
          panels.filter(targetDiv).addClass(opts.panelActiveClass).show();
        }
        tabs.filter("." + opts.tabActiveClass).removeClass(opts.tabActiveClass).children().removeClass(opts.tabActiveClass);
        clicked.parent().addClass(opts.tabActiveClass).children().addClass(opts.tabActiveClass);
        if(!opts.animate){ container.trigger("easytabs:afterChange"); } // this is triggered after the animation delay if opts.animate
        if(typeof callback == 'function'){
          callback();
        }
      }
    },
    selectTabWithHashChange: function(container,tabs,panels){
      var clicked = this;
          url = window.location;
      methods.selectTab.apply( clicked, [container,tabs,panels,function(){
        if(opts.updateHash){
          window.location = url.toString().replace((url.pathname + url.hash), (url.pathname + clicked.attr("href")));
        }
      }] );
    },
    selectTabFromHashChange: function(tabs,panels){
      var container = this;        
          hash = window.location.hash;
          data = container.data("easytabs");
          defaultTab = data.defaultTab;
      if ( ! container.data("easytabs").skipHashUpdateOnce ){
        var tab = methods.selectDefaultTab.apply(tabs).children("a").first();
        if( tabs.find("a[href='" + hash + "']").size() > 0 || (hash == '' && ! defaultTab.hasClass(opts.activeTabClass)) ){
          methods.selectTab.apply( tab, [container,tabs,panels] );
        }
      }else{
        container.data("easytabs").skipHashUpdateOnce = false;
        return false;
      }
    },
    cycleTabs: function(tabs,panels,tabNumber){
      var container = this;
      if(opts.cycle){
        tabNumber = tabNumber % tabs.size();
        tab = $(tabs[tabNumber]).children("a");
        methods.selectTab.apply(tab,[container,tabs,panels]);
        setTimeout(function(){methods.cycleTabs.apply(container,[tabs,panels,(tabNumber + 1)]);}, opts.cycle);
      }
    }
  }
  var easytabsPublicMethods = {
    select: function(tabSelector){
      var container = $(this);
          data = container.data("easytabs");
          tabs = data.tabs;
          panels = data.panels;
          opts = data.opts;
          tab = tabs.filter(tabSelector);
      if ( tab.size() == 0 ) {
        $.error('Tab \'' + tabSelector + '\' does not exist in tab set');
      }
      methods.selectTabWithHashChange.apply(tab.children("a"),[container,tabs,panels]);
    }
  }
  
  
  $.fn.easyTabs = function(options) {
    
    var args = arguments;
    var opts = $.extend({}, $.fn.easyTabs.defaults, options);

    return this.each(function() {
      $container = $(this);
      data = container.data("easytabs");
          
      if ( $.fn.easyTabs.publicMethods[options] && ! data ) {
        $.error( 'You attempted to call ' +  method + ' on' + container + ' without first initializing with $(el).easytabs();' );
      } else if ( $.fn.easyTabs.publicMethods[options] ){
        return $.fn.easyTabs.publicMethods[ options ].apply( $container, Array.prototype.slice.call( args, 1 ));
      } else if ( ! data ) {
        $.fn.easyTabs.methods.init.apply($container);
        
        // enabling back-button with jquery.hashchange plugin
        // http://benalman.com/projects/jquery-hashchange-plugin/
        if(typeof $(window).hashchange == 'function'){
          $(window).hashchange( function(){
            methods.selectTabFromHashChange.apply(container,[tabs,panels]);
          });
        }else if($.address && typeof $.address.change == 'function'){ // back-button with jquery.address plugin http://www.asual.com/jquery/address/docs/
          $.address.change( function(){
            methods.selectTabFromHashChange.apply(container,[tabs,panels]);
          });
        }

        methods.cycleTabs.apply(container,[tabs,panels,0]);
        
      }
      
    });

  }
})(jQuery);