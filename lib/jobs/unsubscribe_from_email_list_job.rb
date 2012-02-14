class Jobs::UnsubscribeFromEmailListJob < Struct.new(:api_key, :list_id, :email)
  #  MailChimp api v1.3
  #
  #  listUnsubscribe(
  #    string apikey,
  #    string id,
  #    string email_address,
  #    boolean delete_member,
  #    boolean send_goodbye,
  #    boolean send_notify
  #  )
  def perform
    hominid = Hominid::API.new(api_key)
    delete_member = false
    send_goodbye = false
    send_notify = false
    response = hominid.list_unsubscribe(list_id, email, delete_member, send_goodbye, send_notify)
    if response
      Rails.logger.info("Success. Removed #{email} from list #{list_id}.")
    else
      Rails.logger.info("Failure. Removing #{email} from list #{list_id} failed with #{response}")
    end
  end
end
