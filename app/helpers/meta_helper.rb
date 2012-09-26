module MetaHelper
  # Removes extra spaces, style, script and truncates data
  def clean_and_truncate(data, length=125)
    result = data.gsub(/\n/, " ").split.join(" ")
    result = Sanitize.clean(result, :remove_contents => ['style','script'])
    result = result.truncate(length, separator:" ")
    result
  end

  # Different Types of Classes Have Different Default Values
  def default_meta_info(meta_data)
    meta_info = {:page_title => nil, :meta_description => nil, :meta_tags => nil, :image_url => nil}

    meta_info[:page_title]       = Sanitize.clean(meta_data.page_title, :remove_contents => ['style','script']) if meta_data.page_title
    meta_info[:meta_description] = clean_and_truncate(meta_data.summary) if meta_data.summary

    if meta_data.is_a?(ContentItem) #&& meta_data.content_type_is_blog_post?
      meta_title = meta_data.page_title ? meta_data.page_title : meta_data.title
      meta_info[:page_title]       = "The Civic Commons #{meta_data.h_content_type}: #{Sanitize.clean(meta_title, :remove_contents => ['style','script'])}"
      meta_info[:image_url]        = ActionController::Base.helpers.asset_path("cc_podcast_small.jpg")
    end

    #puts "meta_data:#{meta_data.inspect}"
    #puts "issue?#{meta_data.is_a?(Issue)}"
    #puts "ancestor?#{meta_data.class}"
    #puts "default_meta_info:#{meta_info.inspect}"
    meta_info
  end
  
  def setup_meta_info_for_conversation_contribution(contribution)
    conversation = contribution.conversation
    @meta_info = {}
    @meta_info[:page_title]= "The Civic Commons Comment on: #{conversation.page_title.present? ? conversation.page_title : conversation.title}"
    @meta_info[:meta_description] = clean_and_truncate(contribution.content)
    @meta_info[:meta_tags] = conversation.meta_tags
    @meta_info[:image_url] = conversation.image.url(:panel) if conversation.respond_to?(:image) && conversation.image.present?
    
    @meta_info = sanitize_meta_values(@meta_info)
  end
  
  def sanitize_meta_values(meta_info)
    meta_info.each{|key,value| meta_info[key] = Sanitize.clean(value, :remove_contents => ['style','script'])}
  end

  # Set Up Page HTML Meta Information
  def setup_meta_info(meta_data)
    @meta_info = default_meta_info(meta_data)

    # Meta Information Overrides Take Preceidence Over Default Data
    @meta_info[:page_title]       = Sanitize.clean(meta_data.title)             if meta_data.title && @meta_info[:page_title].nil? && meta_data.page_title.nil?
    @meta_info[:meta_description] = Sanitize.clean(meta_data.meta_description)  if meta_data.meta_description.present?
    @meta_info[:meta_tags]        = Sanitize.clean(meta_data.meta_tags)         if meta_data.meta_tags.present?
    @meta_info[:image_url]        = Sanitize.clean(meta_data.image.url(:panel)) if meta_data.respond_to?(:image) && meta_data.image.present?
    #puts "post setup_meta_info:#{@meta_info.inspect}"
  end
end
