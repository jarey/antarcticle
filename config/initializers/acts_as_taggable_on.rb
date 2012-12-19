ActsAsTaggableOn::Tag.class_eval do
  def to_param
    CGI.escape name
  end
end
