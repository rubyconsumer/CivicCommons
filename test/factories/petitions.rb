Factory.define :petition do |f|
  f.association :conversation
  f.association :creator, :factory => :person
  f.title 'Title here'
  f.description 'Description here'
  f.resulting_actions 'Resulting Actions here'
  f.signature_needed 2
  f.signers { |signers| [signers.association(:person)] }
end

Factory.define :unsigned_petition, :parent => :petition do |f|
  f.signers []
end