Paperclip.options[:command_path] = if File.exists?("/opt/local/bin/convert")
                                     '/opt/local/bin'
                                   elsif File.exists?("/usr/local/bin/convert")
                                     '/usr/local/bin'
                                   elsif File.exists?("/usr/bin/convert")
                                     '/usr/bin'
                                   else
                                     raise "Cannot find Rmagick utility 'convert'"
                                   end

Paperclip.options[:log_command] = true

CONVERSATION_ATTACHMENT_PATH = if Rails.env == "test"
  ":attachment/:style/:filename"
else
  ":attachment/:id/:style/:filename"
end

