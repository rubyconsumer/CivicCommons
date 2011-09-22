describe('a rating button', function() {
  describe('its ajax before event', function() {
    it('shows the loading image', function() {
      setFixtures('<a class="rating-button">Yarp<p class="loading" style="display: none">Loadin</p></a>'); 
      ratingButton = $('.rating-button').ratingButton();
      ratingButton.trigger('ajax:before');
      expect(ratingButton.children('.loading')).toBeVisible();
    });
  });
  describe('its ajax complete event', function() {
    it('hides the loading image', function() {
      setFixtures('<a class="rating-button">Yarp<p class="loading">Loadin</p></a>'); 
      ratingButton = $('.rating-button').ratingButton();
      ratingButton.trigger('ajax:complete');
      expect(ratingButton.children('.loading')).not.toBeVisible();
    });
  });
});
