ActsAsTaggableOn::Tag.class_eval do
  def to_param
    name
  end
end
