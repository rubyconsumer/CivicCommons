xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.tag!('atom:link', :href => user_url(@user, :format => :xml), :rel => "self", :type => "application/rss+xml")
    xml.title "The Civic Commons: #{@user.name}"
    xml.description "Bio: #{@user.bio}"
    xml.copyright "(c) Copyright #{Date.today.strftime('%Y')} The Civic Commons"
    xml.link user_url(@user)
    xml.image do
      xml.url profile_image_url(@user, 70)
      xml.title "The Civic Commons: #{@user.name}"
      xml.link user_url(@user)
    end
    xml.language "en-us"
    xml.pubDate Time.now.rfc822
    xml.lastBuildDate Time.now.rfc822
    for contribution in @contributions
      contribution = ContributionPresenter.new(contribution, request)
      xml.item do
        xml.title contribution.parent_title
        xml.link contribution.node_url
        xml.guid contribution.node_url
        xml.description contribution.content
        xml.pubDate contribution.created_at.to_s(:rfc822)
      end
    end
  end
end
