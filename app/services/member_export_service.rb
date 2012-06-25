require 'csv'

class MemberExportService
  def self.export_to_csv
    people = Person.all
    csv_string = CSV.generate do |csv|
      
      # header row
      csv << ['ID','Type', 'Name', 'Email', 'Website', 'Zip Code', 'Registered', 'Confirmed', 'Admin', 'Proxy', 'Locked']
      
      # body row
      people.each do |person|
        csv << [
          person.id,
          person.class.name, 
          person.name, 
          person.email, 
          person.website, 
          person.zip_code, 
          person.created_at.to_s(:yyyymmdd), 
          (person.confirmed_at.to_s(:yyyymmdd) if person.confirmed_at?),
          person.admin? ? 'yes' : 'no', 
          person.proxy? ? 'yes' : 'no', 
          person.locked? ? 'yes' : 'no']
      end
    end
    
  end
end