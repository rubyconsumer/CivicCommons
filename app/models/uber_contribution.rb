class UberContribution < Contribution

  # This class will ultimately replace Contributon and all subtypes.
  # AttachedFile and Embedly are the only two subtypes with unique behavior.
  # The validations and behaviors below need to be made optional.

  #############################################################################
  # Copied from contribution_types/embedly_contribution.rb

  #validates :url, presence: true

  validates_format_of :url, :with => URI::regexp(%w(http https)), :allow_blank => true

  validates :embedly_code, presence: true, :if => :url
  validates :embedly_type, presence: true, :if => :url

  def base_url
    match = /^(?<base_url>http[s]?:\/\/(\w|[^\?\/:])+(:\d+)?).*$/i.match(url)
    return match.nil? ? nil : match[:base_url]
  end

  #############################################################################
  # Copied from contribution_types/attached_file.rb

  # supported files:
  # xls, ppt, pdf, doc, txt, xlsx, docx, pptx, rtf, jpg, png

  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => S3Config.credential_file,
    :path => IMAGE_ATTACHMENT_PATH,
    :styles => {:thumb => "75x75>", :medium => "300x300>", :large => "800x800>"}

  # http://rdoc.info/github/thoughtbot/paperclip/master/Paperclip/ClassMethods:validates_attachment_presence
  validates_attachment_presence :attachment#, :unless => ???

  before_attachment_post_process :is_image?

  # Return true if attachment is an image
  # Returns false if it is not an image
  # Does not return nil since before_attachment_post_process relies requires
  # true or false
  def is_image?
    !(attachment_content_type =~ /^image.*/).nil?
  end

end
