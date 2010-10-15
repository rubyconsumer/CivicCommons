class AttachedFile < Contribution
  
  # supported files:
  # xls, ppt, pdf, doc, txt, xlsx, docx, pptx, rtf, jpg, png
  
  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => S3Config.credential_file,
    :path => ":attachment/:id/:style/:filename",
    :styles => {:thumb => "75x75>", :medium => "300x300>", :large => "800x800>"}
      
  validates_attachment_presence :attachment

  def is_image?
    attachment_content_type =~ /^image/
  end
  
end
