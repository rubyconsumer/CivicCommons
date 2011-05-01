def fixture_content(path)
  File.open(File.dirname(__FILE__) + '/../test/fixtures/' + path, 'rb') { |f| f.read }
end

def mask_with_intercept_email(address, subject = nil)
  cc = Civiccommons::Config
  if cc.mailer['intercept']
    subject = "[#{Rails.env.capitalize} - [\"#{address}\"]] #{subject}" unless subject.nil?
    address = cc.mailer['intercept_email']
  end
  return ( subject ? [ address, subject ] : address )
end
