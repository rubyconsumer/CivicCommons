module AvatarHelper
  def user_profile(person)
    if person && person.people_aggregator_id
      link_to_profile(person) do
        loggedin_image(person)
      end
    else
      loggedout_image
    end
  end
  
  def conversation_profile(person)
    if person && person.people_aggregator_id
      link_to_profile(person) do
        profile_image(person, 40)
      end
    else
      profile_image(person, 40)
    end
  end
  
  def contribution_profile(person)
    if person && person.people_aggregator_id
      link_to_profile(person) do
        profile_image(person, 20)
      end
    else
      profile_image(person, 20)
    end
  end
  
  def profile_image(person, size=20)
    <<-EOHTML
    <img src="#{person.avatar.url}" alt="#{person.name}" height="#{size}" width="#{size}"/>
    EOHTML
  end
  
  def loggedin_image(person, size=40)
    <<-EOHTML
    <img src="#{person.avatar.url(:standard)}" alt="#{person.name}" class='callout' height="#{size}" width="#{size}"/>
    EOHTML
  end
  
  def loggedout_image(size=40)
    <<-EOHTML
    <img src='/images/avatar_#{size}.gif' alt='default avatar' class='callout' height='#{size}' width='#{size}'> 
    EOHTML
  end
  
  def link_to_profile(person)
    <<-EOHTML
    <a href="#{Civiccommons::PeopleAggregator::URL}/user/#{person.people_aggregator_id}">
      #{yield}
    </a>
    EOHTML
  end
  
  def avatar_tag(person, options={})
    image_options = {
      :width => 50,
      :height => 50,
      :alt => "avatar",
      :title => person.name}.merge(options)
    image_tag(person.avatar.url("small"), image_options)
  end

end
