module MarkupsHelper

  def markdown_text(text)
    if text.include?(".slim")
      # page =  Slim::Template.new{|t| text}
      # page.render.html_safe
      render inline: text, type: :slim

    else
      options = {
        :autolink => true,
        :space_after_headers => true,
        :fenced_code_blocks => true,
        :no_intra_emphasis => true
      }
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
      markdown.render(text).html_safe
    end
  end

end
