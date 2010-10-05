module CustomMatchers
  RSpec::Matchers.define :have_validation_error do |field=nil, pattern=//|
    match do |object|
      if field 
        assert ! object.valid? 
        assert object.errors[field]
        assert_match(pattern, object.errors[field].to_s) 
      else 
        assert ! object.valid? 
        assert_match(pattern, object.errors.full_messages.join(", "))
      end
    end
  end
end