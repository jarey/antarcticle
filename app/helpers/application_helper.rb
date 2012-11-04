
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

  #def markdown(text)
  #  require 'redcarpet'
  #  options = {:hard_wrap => true, :filter_html => true, :autolink => true, :no_intraemphasis => true, :fenced_code => true, :gh_blockcode => true}
  #  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
  #  raw markdown.render(text)
  #end
  def markdown(text)
    require 'redcarpet'
    renderer = Redcarpet::Render::HTML.new
    options = {
        :hard_wrap        => true,
        :filter_html      => true,
        :autolink         => true,
        :no_intraemphasis => true,
        :fenced_code      => true,
        :gh_blockcode     => true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, options)
    raw redcarpet.render text
  end
end
