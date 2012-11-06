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
    renderer = Redcarpet::Render::HTML.new
    options = {
        :fenced_code_blocks => true,
        :autolink           => true,
        :filter_html        => true,
        :safe_links_only    => true,
        :hard_wrap          => true,
        :no_intra_emphasis  => true,
        :tables             => true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, options)
    redcarpet.render text
  end

  def markdown(text)
    raw markdown_render text
  end
end
