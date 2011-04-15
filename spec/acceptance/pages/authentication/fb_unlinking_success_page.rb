class FbUnlinkingSuccessPage < PageObject
  
  def displayed?
    @page.has_selector?('.fb-auth.unlinking-success.fb-modal')
  end
  
end