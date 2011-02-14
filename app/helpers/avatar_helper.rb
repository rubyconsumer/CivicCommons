module AvatarHelper
  # Create Avatar and Link for a Users Profile
  def user_profile(person)
    if person
      link_to_profile(person) do
        loggedin_image(person)
      end
    else
      loggedout_image
    end
  end

  def text_profile(person)
    if person && person.people_aggregator_id
      link_to_profile(person) do
        person.name
      end
    else
      person.name
    end
  end

  def conversation_profile(person)
    avatar_profile(person, 40)
  end

  def contribution_profile(person)
    avatar_profile(person, 40)
  end

  def featured_profile(person)
    avatar_profile(person, 50)
  end

  def profile_image(person, size=20)
    image_tag person.avatar.url(:standard), alt: person.name, height: size, width: size, title: person.name
  end

  def loggedin_image(person, size=40)
    image_tag person.avatar.url(:standard), alt: person.name, class: 'callout', height: size, width: size
  end

  def loggedout_image(size=40)
    image_tag "avatar_#{size}.gif", alt: 'default avatar', class: 'callout', height: size, width: size
  end

  def avatar_profile(person, size=20)
    if person && person.people_aggregator_id
      link_to_profile(person) do
        profile_image(person, size)
      end
    else
      profile_image(person, size)
    end
  end

  def link_to_profile(person)
    link_to yield, user_path(person), title: person.name
  end

  def link_to_settings(person)
    link_to "Settings", edit_user_path(person), title: "Profile Settings", class: 'user-link'
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
