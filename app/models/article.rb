class Article < ActiveRecord::Base
  # return an open File object that contains our Amazon S3 credentials.
  filename = '/data/TheCivicCommons/shared/config/amazon_s3.yml' # the way it lands on EngineYard
  filename = Rails.root + 'config/amazon_s3.yml' unless File.exist? filename
  s3_credential_file = File.new(filename)

  has_attached_file :image,
    :styles => {
       :subfeature => "70x70>",
       :mainfeature => "340x225>" },
    :storage => :s3,
    :s3_credentials => s3_credential_file,
    :path => ":attachment/:id/:style/:filename"
  
  ['homepage', 'conversation', 'issue'].each do |type|
    scope :"#{type}_main_article", where(:current => true, :main => true, :"#{type}_article" => true)
    scope :"#{type}_sub_articles", where("main != ? AND current = ? AND #{type}_article = ?", true, true, true)
  end

end
