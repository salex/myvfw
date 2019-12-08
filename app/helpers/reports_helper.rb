module ReportsHelper

  def new_reports_link(post,kind)
    type,area = kind.split(".")
    link_to(area,new_report_path(kind:kind), class:'w3-button w3-block w3-green w3-small w3-left-align')
  end

  def program_options
    opt = []
    Report::ProgramOptions.each do |type,areas|
      areas.each do |a|
        opt << "#{type}.#{a}"
      end
    end
    opt 
  end

end
