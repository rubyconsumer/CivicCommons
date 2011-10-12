class Invite
  def self.parse_emails(emails)
    emails.scan(EmailAddressValidation::EMAIL_ADDRESS_INNER_PATTERN)
  end

  def self.send_invites(emails, user, conversation)
    parse_emails(emails).each do |email|
      resource = {:emails => parse_emails(email), :user => user, :conversation => conversation}
      mail = Notifier.invite_to_conversation(resource)
      mail_result = mail.deliver
    end
  end
end
