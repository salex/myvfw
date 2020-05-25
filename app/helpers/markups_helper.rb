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


  def callout_warning(content)
    tag.div class:'w3-container w3-pale-yellow w3-leftbar w3-border-yellow w3-display-container' do  
      concat(tag.span('&times;'.html_safe,class:'w3-button w3-large w3-display-topright',onclick:"this.parentElement.style.display='none'"))
      concat(content)
    end
  end
  def callout_alert(content)
    tag.div class:'w3-container w3-pale-red w3-leftbar w3-border-red w3-display-container' do  
      concat(tag.span('&times;'.html_safe,class:'w3-button w3-large w3-display-topright',onclick:"this.parentElement.style.display='none'"))
      concat(content)
    end
  end
  def callout_info(content)
    tag.div class:'w3-container w3-pale-blue w3-leftbar w3-border-blue w3-display-container' do  
      concat(tag.span('&times;'.html_safe,class:'w3-button w3-large w3-display-topright',onclick:"this.parentElement.style.display='none'"))
      concat(content)
    end
  end
  def callout_success(content)
    tag.div class:'w3-container w3-pale-green w3-leftbar w3-border-green w3-display-container' do  
      concat(tag.span('&times;'.html_safe,class:'w3-button w3-large w3-display-topright',onclick:"this.parentElement.style.display='none'"))
      concat(content)
    end
  end




end
