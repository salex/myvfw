module PostsHelper

  def show_row(label,data)
    content_tag :tr do
      label_th(label) + data_td(data)
    end
  end

  def label_th(label)
    content_tag( :th, label).html_safe
  end

  def data_td(data)
    content_tag( :td, data).html_safe
  end


  # def new_program_link(post,kind)
  #   type,area = kind.split(".")
  #   link_to(area,new_program_report_path(kind:kind), class:'button unpad')
  # end

  # def program_options
  #   opt = []
  #   Report::ProgramOptions.each do |type,areas|
  #     areas.each do |a|
  #       opt << "#{type}.#{a}"
  #     end
  #   end
  #   opt 
  # end

end
