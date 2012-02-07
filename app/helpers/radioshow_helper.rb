module RadioshowHelper
  def radioshow_hosts(radioshow)
    hosts = radioshow.hosts
    if hosts.length > 0
      hosts_html = hosts.collect{|host| text_profile(host) }
      raw "<p><strong>Hosted by:</strong>&nbsp;#{hosts_html.join(' and ')}"
    end
  end
  def radioshow_guests(radioshow)
    guests = radioshow.guests
    if guests.length > 0
      guests_html = guests.collect{|guest| text_profile(guest) }
      raw "<p><strong>Special Guest:</strong>&nbsp;#{guests_html.join(' and ')}"
    end
  end
end