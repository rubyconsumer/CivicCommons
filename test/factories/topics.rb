Factory.define :topic do |f|
  f.sequence(:name) {|n| "Topic #{n}" }
end
