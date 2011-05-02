require "highline/import"

desc "Merge two user accounts by passing in their email addresses: from=email1@example.com to=email2@example.com"
task :merge_account, :needs => :environment do
  begin
    from = get_email('from')
  end while not from_person = Person.find_by_email(from)

  begin
    to = get_email('to')
  end while not to_person = Person.find_by_email(to)

  return unless agree("Merging #{from} to #{to}. Correct?")
  from_person.destroy if to_person.merge_account(from_person)
end

def get_email(email_type)
  email = ENV[email_type] ? ENV[email_type] : nil
  if email.nil? || !Person.find_by_email(email)
    ask("<%= color('#{email_type.upcase}', BOLD) %> Email?") { |q| q.validate = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\z/ }
  else
    email
  end
end