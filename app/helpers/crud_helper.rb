module CrudHelper

  def index_links(instance,opt={})
    header = opt[:header].present? ? opt[:header] : "&nbsp;Listing #{instance.model_name.plural.capitalize}".html_safe
    other_buttons = opt[:buttons].present? ? opt[:buttons] : []
    buttons = []
    add_new_button(buttons,instance) if authorized?
    buttons = buttons + other_buttons unless other_buttons.blank?
    new_bar buttons,header
  end
  def other_links(instance,opt={})
    header = opt[:header].present? ? opt[:header] : "&nbsp;Listing #{instance.model_name.plural.capitalize}".html_safe
    other_buttons = opt[:buttons].present? ? opt[:buttons] : []
    buttons = []
    buttons = buttons + other_buttons unless other_buttons.blank?
    new_bar buttons,header
  end


  def show_links(instance,opt={})
    header = opt[:header].present? ? opt[:header] : "&nbsp;Showing #{instance.model_name.human}".html_safe
    other_buttons = opt[:buttons].present? ? opt[:buttons] : []
    buttons = []
    buttons <<  link_to("List", "/#{instance.model_name.collection}",
        class:' w3-bar-item w3-button w3-large w3-hover-blue-gray') unless opt[:nolist].present?
 
    add_edit_button(buttons,instance) if authorized?
    add_destroy_button(buttons,instance) if authorized?
    buttons = buttons + other_buttons unless other_buttons.blank?
    new_bar buttons,header
  end

  def edit_links(instance,opt={})
    header = opt[:header].present? ? opt[:header] : "&nbsp;Editing #{instance.model_name.human}".html_safe
    other_buttons = opt[:buttons].present? ? opt[:buttons] : []
    buttons = [
      link_to("Show/Cancel", "/#{instance.model_name.collection}/#{instance.id}",
        class:' w3-bar-item w3-button w3-large w3-hover-blue-gray')
    ]
    buttons << link_to("List/Cancel", "/#{instance.model_name.collection}",
      class:' w3-bar-item w3-button w3-large w3-hover-blue-gray') unless opt[:nolist].present?

    add_destroy_button(buttons,instance) if authorized?
    buttons = buttons + other_buttons unless other_buttons.blank?
    new_bar buttons,header
  end

  def new_links(instance,opt={})
    header = opt[:header].present? ? opt[:header] : "&nbsp;New #{instance.model_name.human}".html_safe
    other_buttons = opt[:buttons].present? ? opt[:buttons] : []
    buttons = []
    buttons <<  link_to("List", "/#{instance.model_name.collection}",
        class:' w3-bar-item w3-button w3-large w3-hover-blue-gray') unless opt[:nolist].present?
    
    buttons = buttons + other_buttons unless other_buttons.blank?
    new_bar buttons,header
  end

  def add_new_button(buttons,instance)
    buttons << link_to("New #{instance.model_name.human}",
      "/#{instance.model_name.collection}/new",
      class:' w3-bar-item w3-button w3-large w3-hover-blue-gray')
  end

  def add_edit_button(buttons,instance)
    buttons << link_to("Edit", "/#{instance.model_name.collection}/#{instance.id}/edit",
      class:' w3-bar-item w3-button w3-large w3-hover-blue-gray')
  end

  def add_destroy_button(buttons,instance)
    buttons << link_to('Destroy', "/#{instance.model_name.collection}", data: { confirm: 'Are you sure?' },
      :method => :delete, class:'w3-bar-item w3-button w3-large w3-hover-red')
  end

  def new_bar(buttons,header)
    stuff = ""
    buttons.each do |b|
      stuff += b + "\n"
    end
    h = content_tag(:span,header,class:'link-bar-header w3-large w3-left').html_safe
    content = h + stuff.html_safe
    bar = content_tag( :div, content.html_safe, class:"w3-bar goldey").html_safe
  end

  def authorized?
    Current.user.present? && Current.user.is_admin? && session[:visitor].blank?
  end

end