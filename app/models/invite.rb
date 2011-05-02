class Invite
  def self.parse_emails(emails)
    cleaned_emails = emails.to_s.gsub(/ /, '')
    cleaned_emails.gsub!(/\r\n/, ',')
    cleaned_emails.gsub!(/\n/, ',')
    cleaned_emails.split(',')
  end

  def self.send_invites(emails, user, conversation)
    parse_emails(emails).each do |email|
      resource = {:emails => parse_emails(email), :user => user, :conversation => conversation}
      mail = Notifier.invite_to_conversation(resource)
      mail_result = mail.deliver
    end
  end
end
