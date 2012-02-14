class Jobs::SubscribeToEmailListJob < Struct.new(:api_key, :list_id, :email, :merge_tags)
  #  MailChimp api v1.3
  #
  #  listSubscribe(
  #    string apikey,
  #    string id,
  #    string email_address,
  #    array merge_vars,
  #    string email_type,
  #    bool double_optin,
  #    bool update_existing,
  #    bool replace_interests,
  #    bool send_welcome
  #  )
  def perform
    hominid = Hominid::API.new(api_key)
    email_format = 'html'
    double_opt_in = false
    update_existing = true
    replace_interests = false
    send_welcome = false
    response = hominid.list_subscribe(
      list_id,
      email,
      merge_tags,
      email_format,
      double_opt_in,
      update_existing,
      replace_interests,
      send_welcome
    )
    if response
      Rails.logger.info("Success. Added #{email} to list #{list_id}.")
    else
      Rails.logger.info("Failure. Adding #{email} to list #{list_id} failed with #{response}")
    end
  end
end
