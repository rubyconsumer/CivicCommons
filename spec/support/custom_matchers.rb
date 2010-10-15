module CustomMatchers
  RSpec::Matchers.define :have_validation_error do |field=nil, pattern=//|
    match do |object|
      if field 
        assert ! object.valid? 
        assert have_validation_error(field,pattern)
      else 
        assert ! object.valid?
        assert have_validation_error(field,pattern)
      end
    end
  end
  
  RSpec::Matchers.define :have_generic_error do |field=nil, pattern=//|
    match do |object|
      if field 
        assert object.errors[field]
        assert_match(pattern, object.errors[field].to_s) 
      else 
        assert_match(pattern, object.errors.full_messages.join(", "))
      end
    end
  end
end