require 'nokogiri'

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

#TODO: test for this matcher
RSpec::Matchers.define :have_placeholder do |placeholder, args={}|
  match do |page|
    begin
      if args[:value]
        #TODO: something going wrong when text is blank in textfield
        placeholder_and_value_expr = "//input[@placeholder='#{placeholder}' and @value='#{args[:value]}'] | //textarea[@placeholder='#{placeholder}' and contains(text(), '#{args[:value]}')]"
        page.find(:xpath, placeholder_and_value_expr)
      else
        placeholder_expr = "//input[@placeholder='#{placeholder}'] | //textarea[@placeholder='#{placeholder}']"
        page.find(:xpath, placeholder_expr)
      end
    rescue
      false
    end
  end

  failure_message_for_should do |actual|
    if args[:value]
      "field with placeholder '#{placeholder}' and value '#{args[:value]}' not found"
    else
      "field with placeholder '#{placeholder}' not found"
    end
  end

  failure_message_for_should_not do |actual|
    if args[:value]
      "found field with placeholder '#{placeholder}' and value '#{args[:value]}'"
    else
      "found field with placeholder '#{placeholder}'"
    end
  end

  description do
    if args[:value]
      "have field with placeholder '#{placeholder}' and value '#{args[:value]}'"
    else
      "have field with placeholder '#{placeholder}'"
    end
  end
end