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
    if person
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
    image_tag person.avatar_url, alt: person.name, height: size, width: size, title: person.name, class: 'callout'
  end

  def loggedin_image(person, size=40)
    profile_image(person, size)
  end

  def loggedout_image(size=40)
    image_tag "avatar_#{size}.gif", alt: 'default avatar', class: 'callout', height: size, width: size
  end

  def avatar_profile(person, size=20)
    if person
      link_to_profile(person) do
        profile_image(person, size)
      end
    else
      profile_image(person, size)
    end
  end

  def link_to_profile(person)
    link_to yield, user_url(person), title: person.name
  end

  def link_to_settings(person)
    link_to "Settings", edit_user_url(person), title: "Profile Settings", class: 'user-link'
  end

  # Creates an image_tag for a particular person
  # options includes options passed along to image_tag along with
  # :style_name which is a directive for paperclip which determines the
  # ':style' paperclip should use for the image. 
  #
  def avatar_tag(person, options={})
    style_name = options.delete(:style_name) || :small
    url = person.avatar.url(style_name)
    if request.ssl? then url = url.gsub(/http:/i, 'https:') end
    image_options = {
      :width => 50,
      :height => 50,
      :alt => "avatar",
      :title => person.name}.merge(options)
    image_tag(url, image_options)
  end

end
