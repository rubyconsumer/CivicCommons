class IssuePresenter < PresenterBase
  def filed_under
    @object.topics.map do |topic|
      if topic.id
        """
        <span data-topic-id='#{topic.id}'>
          <a href='/issues/?topic=#{topic.id}'>#{topic.name}</a>
        </span>
        """
      else
        topic.name
      end
    end.join(", ")
  end
end
