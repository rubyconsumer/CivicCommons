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
        profile_image(person, 60)
      end
    else
      profile_image(person, 60)
    end
  end
  
  def featured_profile(person)
    if person && person.people_aggregator_id
      link_to_profile(person) do
        profile_image(person, 50)
      end
    else
      profile_image(person, 50)
    end
  end
  
  def contribution_profile_text(person)
    if person && person.people_aggregator_id
      link_to_profile(person) do
        person.name
      end
    else
      person.name
    end
  end
  
  def profile_image(person, size=20)
    <<-EOHTML
    <img src="#{person.avatar.url(:standard)}" alt="#{person.name}" height="#{size}" width="#{size}" title="#{person.name}"/>
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
    if current_person == person
      profile_link = "me"
    else
      profile_link = "user/#{person.people_aggregator_id}"
    end
    <<-EOHTML
    <a href="#{pa_link(profile_link)}" title="#{person.name}">
      #{yield}
    </a>
    EOHTML
  end
  
  # Creates an image_tag for a particular person
  # options includes options passed along to image_tag along with
  # :style_name which is a directive for paperclip which determines the
  # ':style' paperclip should use for the image. 
  #
  def avatar_tag(person, options={})
    style_name = options.delete(:style_name) || :small
    image_options = {
      :width => 50,
      :height => 50,
      :alt => "avatar",
      :title => person.name}.merge(options)
    image_tag(person.avatar.url(style_name), image_options)
  end

end
