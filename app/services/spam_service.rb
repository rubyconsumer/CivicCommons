class SpamService
  EMAIL_DOMAINS_TO_REJECT = Regexp.new('163\.com|yeah\.net|21cn\.com','i')
  
  def self.spam?(email)
    EMAIL_DOMAINS_TO_REJECT.match(email) ? true : false
  end
end