# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :valid_invite, :class => Invite do |f|
  f.invitation_token "AA0123"
  f.invitation_sent_at "2010-11-04 14:14:58"
  f.valid_invite true
  f.email "someemail@example.com"
end

Factory.define :invalid_invite, :class => Invite do |f|
  f.invitation_token "INVALID"
  f.invitation_sent_at "2010-11-04 14:14:58"
  f.valid_invite false
  f.email "someemail@example.com"
end
