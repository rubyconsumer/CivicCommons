describe('editing a contribution', function () {
  describe('cancelling the edit box', function() {
    it('should remove the contribution editor', function() {
      contribution = new ContributionView();
      contribution.switchToEditMode();
      contribution.cancelEditMode();
      expect(contribution.editTool).not.toExist();
    });
  });
});

