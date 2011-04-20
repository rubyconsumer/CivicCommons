class Jobs::SubscribeToMarketingEmailJob < Struct.new(:api_key, :list_id, :email, :merge_tags, :email_format, :double_opt_in)
  def perform
    h = Hominid::API.new(api_key)
    h.list_subscribe(list_id, email, merge_tags, email_format, double_opt_in)
    Rails.logger.info("Success. Added #{email} to list #{list_id}.")
  end
end

