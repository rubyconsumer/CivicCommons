class AttachedFile < Contribution
  
  # paperclip bug: if you don't specify the path, you will get
  # a stack overflow when trying to upload an image.
  # return an open File object that contains our Amazon S3 credentials.
  filename = '/data/TheCivicCommons/shared/config/amazon_s3.yml' # the way it lands on EngineYard
  filename = Rails.root + 'config/amazon_s3.yml' unless File.exist? filename
  s3_credential_file = File.new(filename)

  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => s3_credential_file,
    :path => ":attachment/:id/:style/:filename",
    :styles => {:thumb => "75x75>", :medium => "300x300>", :large => "800x800>"}
      
  validates_attachment_presence :attachment

  def is_image?
    attachment_content_type =~ /^image/
  end
  
end
