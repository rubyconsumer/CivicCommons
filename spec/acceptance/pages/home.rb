module CivicCommonsDriver
module Pages
class Home
  SHORT_NAME = :home
  include Page 
  add_link(:start_conversation, "Start a Conversation", :accept_responsibilities)
  location('/')
end
end
end
