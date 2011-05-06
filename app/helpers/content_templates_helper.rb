module ContentTemplatesHelper

  def parse_content_template(id)
    template = ContentTemplate.find(id)
    return CCML.parse(template.template, controller.request.url) unless template.nil?
  rescue => error
    return ''
  end

end
