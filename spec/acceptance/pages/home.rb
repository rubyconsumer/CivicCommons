module CivicCommonsDriver
module Pages
class Home
  SHORT_NAME = :home
  LOCATION = '/'
  include Page 
  add_link(:start_conversation, "Start a Conversation", :accept_responsibilities)
end
end
end
