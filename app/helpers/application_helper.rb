module ApplicationHelper

  def control_group(resource, field, &block)
    html = ""
    if resource.errors[field].present?
      html << '<div class="control-group error">'
    else
      html << '<div class="control-group">'
    end
    html << '<div class="controls">'
    html << capture(&block)
    html << "</div>"
    html << "</div>"
    raw(html)
  end
end
