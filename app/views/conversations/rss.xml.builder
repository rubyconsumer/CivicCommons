xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.tag!('atom:link', :href => blog_index_url(:format => :xml), :rel => "self", :type => "application/rss+xml")
    xml.title "The Civic Commons: Conversations"
    xml.description "The Civic Commons is a new way to bring communities together with conversation and emerging technology. We’re focused on building conversations and connections that have the power to become informed, productive collective civic action."
    xml.copyright "(c) Copyright #{Date.today.strftime('%Y')} The Civic Commons"
    xml.link blog_index_url
    xml.image do
      xml.url "#{root_url}images/cc_podcast.jpg"
      xml.title 'The Civic Commons: Conversations'
      xml.link blog_index_url
    end
    xml.language "en-us"
    xml.pubDate Time.now.rfc822
    xml.lastBuildDate Time.now.rfc822
    for conversation in @conversations
      xml.item do
        xml.title conversation.title
        xml.link conversation_url(conversation)
        xml.guid conversation_url(conversation)
        xml.description conversation.summary
        xml.pubDate conversation.created_at.to_s(:rfc822)
      end
    end
  end
end
