class SpamService
  attr_accessor :domain_pattern, :email
  
  def initialize(email)
    @email = email
    create_regex_pattern
  end
  
  def spam?
    return false if @domain_pattern.blank?  
    email_domains_to_reject.match(@email) ? true : false
  end
  
  def email_domains_to_reject
    Regexp.new(@domain_pattern,'i') 
  end
  
  def create_regex_pattern
    # creates a regex pattern like:
    # 163\.com|yeah\.net|21cn\.com
    domains = EmailRestriction.select(:domain).all.collect do |record|
      Regexp.escape(record.domain)
    end
    @domain_pattern = domains.join('|')
  end
  
  def self.spam?(email)
    mail = SpamService.new(email)
    mail.spam?
  end
  
end