class Article < ActiveRecord::Base
  # return an open File object that contains our Amazon S3 credentials.
  filename = '/data/TheCivicCommons/shared/config/amazon_s3.yml' # the way it lands on EngineYard
  filename = Rails.root + 'config/amazon_s3.yml' unless File.exist? filename
  s3_credential_file = File.new(filename)

  has_attached_file :image,
    :styles => {
       :subfeature => "60x60>",
       :mainfeature => "300x225" },
    :storage => :s3,
    :s3_credentials => s3_credential_file,
    :path => ":attachment/:id/:style/:filename"

end
