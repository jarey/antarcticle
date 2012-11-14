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

  def markdown_render(text)
    require 'redcarpet'
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    options = {
        :fenced_code_blocks => true,
        :autolink           => true,
        :safe_links_only    => true,
        :strikethrough      => true,
        :lax_spacing        => true,
        :no_intra_emphasis  => true,
        :tables             => true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, options)
    redcarpet.render text
  end

  def markdown(text)
    markdown_render(text).html_safe
  end
end
