class IssuePage < PageObject

  def visit_page(issue)
    visit issue_path(issue)
  end
end
