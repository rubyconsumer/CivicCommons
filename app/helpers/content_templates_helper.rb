module ContentTemplatesHelper

  def parse_content_template(id)
    begin
      template = ContentTemplate.find(id)
      parsed = CCML.parse(template.template, controller.request.url) unless template.nil?
    rescue Exception => e
      parsed = ''
    end
    return raw parsed
  end

end
