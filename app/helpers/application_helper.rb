module ApplicationHelper

  def control_group(resource, field, &block)
    error_class = " error" if resource.errors[field].present?
    content_tag :div, class: "control-group #{error_class}" do
      content_tag :div, class: "controls" do
        capture(&block)
      end
    end
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

  def yield_for(content_sym, default)
    output = content_for(content_sym)
    output = default if output.blank?
    output
  end
end
