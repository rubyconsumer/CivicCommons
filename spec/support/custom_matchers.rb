module CustomMatchers
  
  def match_errors(object, field=nil, pattern=//)
    if field
      assert object.errors[field]
      assert_match(pattern, object.errors[field].to_s)
    else
      assert ! object.valid? 
      assert_match(pattern, object.errors.full_messages.join(", "))
    end
  end
  
  RSpec::Matchers.define :have_validation_error do |field=nil, pattern=//|
    match do |object|
      assert ! object.valid? 
      match_errors(object,field,pattern)
    end
  end
  
  RSpec::Matchers.define :have_generic_error do |field=nil, pattern=//|
    match do |object|
      match_errors(object,field,pattern)
    end
  end
end