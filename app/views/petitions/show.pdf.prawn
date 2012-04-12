prawn_document do |pdf|
  print_service = PetitionPrintService.new(self, pdf, @petition)
  print_service.render
end
